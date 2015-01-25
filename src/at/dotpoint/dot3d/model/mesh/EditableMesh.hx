package at.dotpoint.dot3d.model.mesh;

import haxe.ds.Vector;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.math.vector.Vector3;
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

	private var vertexLookup:StringMap<StringMap<Int>>;
	private var countLookup:StringMap<Int>;

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
		
		this.vertexLookup 	= new StringMap<StringMap<Int>>();
		this.countLookup	= new StringMap<Int>();

		this.vertexLookup.set( "indices", new StringMap<Int>() );
		this.countLookup.set( "indices", 0 );
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
		var vindex:Int = this.getVertexIndex( "indices", registerIndices );

		if( vindex > this.data.signature.numVertices )
			throw "already set maximum amount of vertices";

		// ---------------- //

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
		
		if( !this.countLookup.exists( this.currentType.ID ) )
			this.countLookup.set( this.currentType.ID, 0 );

		if( !this.vertexLookup.exists( this.currentType.ID ) )
			this.vertexLookup.set( this.currentType.ID, new StringMap<Int>()  );
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
	public function addVertexData( data:Array<Float>, ?type:RegisterType ):Int
	{
		if( type != null )
			this.startVertexData( type );
		
		if( this.currentType == null )
			throw "must call startVertexData first";

		// ------------- //

		var index:Int = this.getVertexIndex( this.currentType.ID, data );

		this.data.setVertexData( this.currentType, index, data );

		return index;
	}

	/**
	 *
	 */
	private function getVertexIndex( type:String, values:Array<Dynamic> ):Int
	{
		if( this.vertexLookup == null ) // might be on max amount of vertices
			return -1;

		// ------------------- //

		var index:Int = this.countLookup.get( type );

		var lookup:StringMap<Int> = this.vertexLookup.get( type );
		var vsig:String 	 = values.join("/");

		if( lookup.exists( vsig ) )
		{
			return lookup.get( vsig );
		}
		else
		{
			lookup.set( vsig, index );
			this.countLookup.set( type, index + 1 );
		}

		return index;
	}

	// ************************************************************************ //
	// Helper
	// ************************************************************************ //

	/**
	 *
	 */
	public function addPosition( vertex:Vector3 ):Int
	{
		return this.addVertexData( [vertex.x, vertex.y, vertex.z], Register.VERTEX_POSITION );
	}

	/**
	 *
	 * @param	vIndex1
	 * @param	vIndex2
	 * @param	vIndex3
	 */
	private function addNormal( vIndex1:Int, vIndex2:Int, vIndex3:Int, combine:Bool = true ):Vector3
	{
		var cross:Vector3 = this.calculatetNormal( vIndex1, vIndex2, vIndex3 );

		if( !combine )
		{
			this.data.setVertexData( Register.VERTEX_NORMAL, vIndex1, [cross.x, cross.y, cross.z] );
			this.data.setVertexData( Register.VERTEX_NORMAL, vIndex2, [cross.x, cross.y, cross.z] );
			this.data.setVertexData( Register.VERTEX_NORMAL, vIndex3, [cross.x, cross.y, cross.z] );

			return cross;
		}

		// --------------------- //

		var normal:Vector3 = new Vector3();
		var total:Vector3  = new Vector3();

		var indices:Vector<Int> = new Vector<Int>( 3 );
			indices[0] = vIndex1;
			indices[1] = vIndex2;
			indices[2] = vIndex3;

		for( index in indices )
		{
			var na:Array<Float> = this.data.getVertexData( Register.VERTEX_NORMAL, index );

			if( na == null )
			{
				na = new Array<Float>();
				na[0] = 0;
				na[1] = 0;
				na[2] = 0;
			}

			// --------- //

			normal.set( na[0], na[1], na[2] );

			total = Vector3.add( normal, cross, total );
			total.normalize();

			na[0] = total.x;
			na[1] = total.y;
			na[2] = total.z;

			this.data.setVertexData( Register.VERTEX_NORMAL, index, na );
		}

		return total;
	}

	/**
	 *
	 * @param	vIndex1
	 * @param	vIndex2
	 * @param	vIndex3
	 */
	private function calculatetNormal( vIndex1:Int, vIndex2:Int, vIndex3:Int ):Vector3
	{
		var v1a:Array<Float> = this.data.getVertexData( Register.VERTEX_POSITION, vIndex1 );
		var v2a:Array<Float> = this.data.getVertexData( Register.VERTEX_POSITION, vIndex2 );
		var v3a:Array<Float> = this.data.getVertexData( Register.VERTEX_POSITION, vIndex3 );

		var v1:Vector3 = new Vector3( v1a[0], v1a[1], v1a[2] );
		var v2:Vector3 = new Vector3( v2a[0], v2a[1], v2a[2] );
		var v3:Vector3 = new Vector3( v3a[0], v3a[1], v3a[2] );

		// --------------------- //

		var sub1:Vector3 = Vector3.subtract( v2, v1, new Vector3() );
		var sub2:Vector3 = Vector3.subtract( v3, v1, new Vector3() );

		var cross:Vector3 = Vector3.cross( sub1, sub2 );
			cross.normalize();

		return cross;
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
		this.countLookup  = null;
		
		this.currentType  = null;
	}
}