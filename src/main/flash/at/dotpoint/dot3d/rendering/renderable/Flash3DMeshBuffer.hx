package flash.at.dotpoint.dot3d.rendering.renderable;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshSignature;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.Vector;
import haxe.at.dotpoint.logger.Log;

/**
 * ...
 * @author RK
 */
class Flash3DMeshBuffer
{
	
	/**
	 * 
	 */
	public var signature:MeshSignature;
	
	/**
	 * 
	 */
	public var indexBuffer:IndexBuffer3D;
	
	/**
	 * 
	 */
	public var vertexBuffer:VertexBuffer3D;
	
	/**
	 * 
	 */
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
	public function allocate( context:Context3D, data:IMeshData ):Void
	{
		if ( this.isAllocated ) 
		{
			Log.warn( "already allocated: " + Log.getCallstack() );
			this.dispose();
		}
		
		this.signature = data.getMeshSignature();
		
		// --------------------------- //
		
		var indices:Vector<UInt> = this.createIndexStream( data );		
		
		this.indexBuffer = context.createIndexBuffer( indices.length );
		this.indexBuffer.uploadFromVector( indices, 0, indices.length );	
		
		// --------------------------- //
		
		var vertices:Vector<Float> = this.createVertexStream( data );
		
		var numVertices:Int = this.signature.numVertices;
		var vertexSize:Int  = 0;
		
		for( type in signature )
			vertexSize += type.size;
		
		this.vertexBuffer = context.createVertexBuffer( numVertices, vertexSize );
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
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// Index/Vertex Stream
	
	/**
	 * converts internal representation
	 */
	private function createIndexStream( data:IMeshData ):Vector<UInt>
	{
		var stream:Vector<UInt> = new Vector<UInt>( this.signature.numTriangles * 3, true );
		
		for( t in 0...signature.numTriangles )
		{
			var indices:Array<Int> = data.getIndicesByTriangle( t );
			
			for( i in 0...3 )
				stream[t * 3 + i] = indices[i];
		}
		
		return stream;
	}
	
	/**
	 *  converts internal representation
	 */
	public function createVertexStream( data:IMeshData ):Vector<Float>
	{
		var typelist:Array<RegisterType> = this.signature.toArray();
		
		// -------------- //
		
		var vertexSize:Int = 0;
		
		for( type in typelist )
			vertexSize += type.size;
		
		// -------------- //
		
		var stream:Vector<Float> = new Vector<Float>( this.signature.numVertices * vertexSize, true );
		
		for( v in 0...signature.numVertices )
		{
			var curTypeSize:Int = 0;			
			var registerIndices:Array<Int> 	= data.getIndicesByVertex( v );		
			
			for( t in 0...typelist.length )
			{
				var registerData:Array<Float> = data.getRegisterData( registerIndices[t], typelist[t] );
				
				for( d in 0...registerData.length )
				{
					stream[ (v * vertexSize) + (curTypeSize) + d ] = registerData[ d ];
				}
				
				curTypeSize += registerData.length;
			}
		}
		
		return stream;
	}
}