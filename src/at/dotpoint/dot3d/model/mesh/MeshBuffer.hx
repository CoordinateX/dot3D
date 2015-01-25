package at.dotpoint.dot3d.model.mesh;

import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.Vector;


/**
 * allocates and deallocates the GPU vertex and index buffer data using MeshData and Context3D
 */
class MeshBuffer
{

	public var indexBuffer:IndexBuffer3D;
	public var vertexBuffer:VertexBuffer3D;
	
	public var isAllocated(get,null):Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new(){		
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
	// allocate / dispose
	
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
		
		// --------------------------- //
		
		var indices:Vector<UInt> = data.createIndexStream();		
		
		this.indexBuffer = context.createIndexBuffer( indices.length );
		this.indexBuffer.uploadFromVector( indices, 0, indices.length );	
		
		// --------------------------- //
		
		var vertices:Vector<Float> = data.createVertexStream();
		
		var numVertices:Int = data.signature.numVertices;
		var sizeVertex:Int  = data.signature.getTotalRegisterSize();
		
		this.vertexBuffer = context.createVertexBuffer( numVertices, sizeVertex );
		this.vertexBuffer.uploadFromVector( vertices, 0, numVertices );
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

