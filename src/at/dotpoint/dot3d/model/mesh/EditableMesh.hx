package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.ds.StringMap;

/**
 * ...
 * @author RK
 */
class EditableMesh extends Mesh
{

	private var vertexLookup:StringMap<Int>;
	
	private var numSetVertices:Int;
	private var numSetFaces:Int;
	
	private var currentType:RegisterType;
	private var currentNumData:Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( signature:MeshSignature ) 
	{
		super( signature );	
		
		this.vertexLookup = new StringMap<Int>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //		

	/**
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
	 * 
	 * @param	type
	 */
	public function startVertexData( type:RegisterType ):Void
	{
		this.currentType = type;
		this.currentNumData = 0;
	}
	
	/**
	 * 
	 * @param	type
	 * @param	data
	 */
	public function addVertexData( data:Array<Float> ):Void
	{
		if( this.currentType == null )
			throw "must call startVertexData first";
		
		this.data.setVertexData( this.currentType, this.currentNumData, data );
		this.currentNumData++;
	}
	
	// -------------------------------- //
	// -------------------------------- //
	
	/**
	 * 
	 */
	public function finalize():Void
	{
		this.vertexLookup = null;
		this.currentType  = null;
	}
}