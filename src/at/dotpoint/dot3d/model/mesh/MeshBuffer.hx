package at.dotpoint.dot3d.model.mesh;

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
	
	private function new( numVertices:Int ) 
	{
		super( numVertices );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	private function get_isAllocated():Bool
	{
		return this.indexBuffer != null && this.vertexBuffer != null;
	}
	
	/**
	 * 
	 * @param	context
	 * @param	mesh
	 */
	public function allocate( context:Context3D ):Void
	{
		if ( this.isAllocated ) 
		{
			trace( "already allocated" );
			this.dispose();
		}
		
		// ------------- //
		
		var indices::Array<UInt> = data.indices;		
		
		this.indexBuffer = context.createIndexBuffer( indices.length );
		this.indexBuffer.uploadFromVector( flash.Vector.ofArray( indices ), 0, indices.length );	
		
		// ------------- //
		// TODO: optimize
		
		var numVertices:Int = data.numVertices;
		var typeList:Array<RegisterType> = data.getDataTypes();
		
		var vlist:Array<Float> = new Array<Float>();			
		var vertex:Vertex = new Vertex();				
		
		for ( k in 0...numVertices )
		{
			vertex = data.getVertex( k, vertex );
			
			for ( type in typeList )
			{
				var data:Array<Float> = vertex.getData( type );
				
				for ( value in data )
				{
					vlist.push( value );
				}			
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

