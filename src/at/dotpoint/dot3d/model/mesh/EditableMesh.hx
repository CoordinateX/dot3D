package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.ds.StringMap;

/**
 * Mesh with usefull methodes to quickly create a mesh without any file import and parsing.<br/>
 * Has a few additional internal data structures that should be destroyed afterwards to conserve
 * data usage. does not (yet) provide a dynamic signature - so you must specify the allocation size
 * via MeshSignature before creating the mesh.
 * 
 * @author RK
 */
class EditableMesh extends Mesh
{

	private var vertexLookup:StringMap<Int>;
	private var typeLookup:StringMap<Int>;
	
	private var numSetVertices:Int;
	private var numSetFaces:Int;
	
	private var currentType:RegisterType;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * uses the signature to allocate the required space for the mesh and defining which
	 * types of vertex data are allowed to store and access. 
	 */
	public function new( signature:MeshSignature ) 
	{
		super( signature );	
		
		this.vertexLookup = new StringMap<Int>();
		this.typeLookup = new StringMap<Int>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //		

	/**
	 * creates a face using the provided registerIndices where each value is an index
	 * pointing to a unique vertex-data. a group of the size of the signature (all RegisterTypes)
	 * defines a vertex and 3 vertices must be provided to define a face/triangle. 
	 * <br/><br/>
	 * the methode checks wheter or not the defined vertex is actually unique or if the combination
	 * of vertex data has already been stored. (so no need to manually set vertices)
	 * <br/><br>
	 * example registerIndices: [0,0,0, 1,1,0, 2,2,0]<br/>
	 * where each tuple of 3 defines a vertex and all 3 define the face. the first index of each vertex
	 * points to the position register data, the second to uv and so on; depending on the signature
	 * 
	 * @param	registerIndices
	 */
	public function createFace( registerIndices:Array<Int> ):Void
	{
		var size:Int = this.data.signature.size();
		var length:Int = 3 * size;
		
		if( registerIndices.length != length )
			throw "must provide exactly " + length + " indices";
			
		if( this.numSetFaces > this.data.signature.numFaces )
			throw "already set maximum amount of faces";
		
		// ----------------- //
		
		var face:Array<Int> = new Array<Int>();
		
		for( v in 0...3 )
		{
			var start:Int = v * size;
			var values:Array<Int> = registerIndices.slice( start, start + size );
			
			face[v] = this.setVertexIndices( values );			
		}
		
		this.data.setFaceIndices( this.numSetFaces, face );
		this.numSetFaces++;
	}
	
	/**
	 * internally used to save a vertex in case it is unique and return
	 * the vertex-index in either case
	 * 
	 * @param	registerIndices
	 * @return 	vertex index
	 */
	private function setVertexIndices( registerIndices:Array<Int> ):Int
	{
		var vindex:Int = this.numSetVertices;
		
		// ---------------- //
		// duplicate?
		
		if( this.vertexLookup != null ) // might be on max amount of vertices
		{
			var vsig:String = registerIndices.join("/");		
		
			if( this.vertexLookup.exists( vsig ) )
			{
				return this.vertexLookup.get( vsig );
			}
			else
			{
				this.vertexLookup.set( vsig, vindex );
			}
		}
		
		// ---------------- //
		
		if( this.numSetVertices > this.data.signature.numVertices )
			throw "already set maximum amount of vertices";
		
		this.data.setVertexIndices( vindex, registerIndices );
		this.numSetVertices++;
		
		return vindex;
	}
	
	// -------------------------------- //
	// -------------------------------- //
	
	/**
	 * specify that all following addVertexData calls are of the given RegisterType<br/>
	 * note that in case addVertexData specifies a type manually this methode needs to be 
	 * called again.
	 * 
	 * @param	type
	 */
	public function startVertexData( type:RegisterType ):Void
	{
		this.currentType = type;
		
		if( !this.typeLookup.exists( this.currentType.ID ) )
			this.typeLookup.set( this.currentType.ID, 0 );
	}
	
	/**
	 * adds an additional vertexdata of the last set type (when used startVertexData) or
	 * given type (when the second param is used). note that in the case of specifying a
	 * type any value set by startVertexData is overwriten. 
	 * <br/><br/>
	 * Internally counts the vertex data for the given type and always sets a new one
	 * 
	 * @param	type
	 * @param	data
	 */
	public function addVertexData( data:Array<Float>, ?type:RegisterType ):Void
	{
		if( type != null )
			this.startVertexData( type );
		
		if( this.currentType == null )
			throw "must call startVertexData first";
		
		var index:Int = this.typeLookup.get( this.currentType.ID );
		this.typeLookup.set( this.currentType.ID, index + 1 );
		
		this.data.setVertexData( this.currentType, index, data );
	}
	
	// -------------------------------- //
	// -------------------------------- //
	
	/**
	 * destroys any data used while creating the mesh in order to free up
	 * resources. override this methode in case you use your own temporary
	 * data while creating the mesh. 
	 * <br/><br/>
	 * this methode is not called automatically, call it once you are done creating
	 */
	public function finalize():Void
	{
		this.vertexLookup = null;
		this.typeLookup   = null;
		
		this.currentType  = null;
	}
}