package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.container.IRegisterContainer;
import at.dotpoint.dot3d.model.register.RegisterType;
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;



/**
 * Stores the Attribute-Values for all vertices of a given mesh. Position, Normals, UV's etc.
 * Specifies pure geometry only, no materials
 */
class MeshBuffer
{

	public var indexBuffer:IndexBuffer3D;
	public var vertexBuffer:VertexBuffer3D;
	
	public var isAllocated(get,null):Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new() 
	{
		
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	private function get_isAllocated():Bool
	{
		return this.indexBuffer != null || this.vertexBuffer != null;
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	//allocate
	
	/**
	 * 
	 * @param	context
	 * @param	mesh
	 */
	public function allocate( context:Context3D, data:MeshData ):Void
	{
		if ( this.isAllocated ) 
		{
			trace( "already allocated" );
			this.dispose();
		}
		
		this.allocateIndexBuffer( context, data );
		this.allocateVertexBuffer( context, data );
	}	
	
	/**
	 * 
	 * @param	context
	 * @param	data
	 */
	private function allocateIndexBuffer( context:Context3D, data:MeshData ):Void
	{
		var indices:Array<UInt> = data.indices;		
		
		this.indexBuffer = context.createIndexBuffer( indices.length );
		this.indexBuffer.uploadFromVector( flash.Vector.ofArray( indices ), 0, indices.length );	
	}
	
	/**
	 * 
	 * @param	context
	 * @param	data
	 */
	private function allocateVertexBuffer( context:Context3D, data:MeshData ):Void
	{
		var vertices:IRegisterContainer = data.vertices;
		
		var numVertices:Int = vertices.numEntries;
		var typeList:Array<RegisterType> = vertices.getRegisterTypes();
		
		var vlist:Array<Float> = new Array<Float>();			
		var tmp:Array<Float> = new Array<Float>();				
		
		for ( k in 0...numVertices )
		{
			for ( type in typeList )
			{
				tmp = vertices.getData( type, k, tmp );
				
				for ( j in 0...type.size )
					vlist.push( tmp[j] );
			}
		}
		
		// ------------- //
		
		var numVData:Int = 0;
		
		for ( type in typeList )
		{
			numVData += type.size;		
		}
		
		// ------------- //
		
		this.vertexBuffer = context.createVertexBuffer( numVertices, numVData );
		this.vertexBuffer.uploadFromVector( flash.Vector.ofArray( vlist ), 0, numVertices );
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// dispose
	
	/**
	 * 
	 */
	public function dispose():Void
	{
		if ( this.indexBuffer != null )
		{
			this.indexBuffer.dispose();
			this.indexBuffer = null;
		}
		
		if ( this.vertexBuffer != null )
		{
			this.vertexBuffer.dispose();
			this.vertexBuffer = null;
		}
	}
}

