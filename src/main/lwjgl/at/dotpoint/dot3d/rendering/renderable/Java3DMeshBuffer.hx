package lwjgl.at.dotpoint.dot3d.rendering.renderable;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshSignature;
import haxe.at.dotpoint.display.rendering.register.RegisterFormat;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.logger.Log;
import java.NativeArray;
import java.types.Int16;
import java.types.Int8;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL15;
import org.lwjgl.opengl.GL20;
import org.lwjgl.opengl.GL30;
import org.lwjgl.BufferUtils;
import java.nio.FloatBuffer;
import java.nio.ByteBuffer;

/**
 * ...
 * @author RK
 */
class Java3DMeshBuffer
{

	/**
	 *
	 */
	public var signature:MeshSignature;

	/**
	 *
	 */
	public var isAllocated(get, null):Bool;

	// -------- //

	/**
	 *
	 */
	public var ptr_vertexArray(default, null):Int;

	/**
	 *
	 */
	public var ptr_indexBuffer(default, null):Int;

	/**
	 *
	 */
	public var ptr_vertexBuffer(default, null):Int;


	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.ptr_vertexArray  = -1;
		this.ptr_indexBuffer  = -1;
		this.ptr_vertexBuffer = -1;
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	private function get_isAllocated():Bool
	{
		return this.ptr_vertexArray != -1 && this.ptr_indexBuffer != -1 && this.ptr_vertexBuffer != -1;
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// allocate

	/**
	 *
	 * @param	context
	 * @param	mesh
	 */
	public function allocate( data:IMeshData ):Void
	{
		if ( this.isAllocated )
		{
			Log.warn( "already allocated: " + Log.getCallstack() );
			this.dispose();
		}

		this.signature = data.getMeshSignature();

		// --------------------------- //

		this.allocateVertexArray();
		this.allocateVertexBuffer( data );

		GL30.glBindVertexArray( 0 );

		this.allocateIndexBuffer( data );

		GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, 0 );
		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, 0 );
	}

	/**
	 *
	 */
	private function allocateVertexArray():Void
	{
		this.ptr_vertexArray  = GL30.glGenVertexArrays();
		GL30.glBindVertexArray( this.ptr_vertexArray );
	}

	/**
	 *
	 */
	private function allocateVertexBuffer( data:IMeshData ):Void
	{
		this.ptr_vertexBuffer = GL15.glGenBuffers();

		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, this.ptr_vertexBuffer );
        GL15.glBufferData( GL15.GL_ARRAY_BUFFER, this.createVertexBuffer( data ), GL15.GL_STATIC_DRAW );

		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, 0 );
	}

	/**
	 *
	 */
	private function allocateIndexBuffer( data:IMeshData ):Void
	{
		this.ptr_indexBuffer  = GL15.glGenBuffers();

		GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, this.ptr_indexBuffer );
        GL15.glBufferData( GL15.GL_ELEMENT_ARRAY_BUFFER, this.createIndexBuffer( data ), GL15.GL_STATIC_DRAW );

		GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, 0 );
	}

	/**
	 *
	 * @param	data
	 * @return
	 */
	private function createIndexBuffer( data:IMeshData ):ByteBuffer
	{
		var stream:NativeArray<Int8> = new NativeArray<Int8>( this.signature.numTriangles * 3 );

		for( t in 0...signature.numTriangles )
		{
			var indices:Array<Int> = data.getIndicesByTriangle( t );

			for( i in 0...3 )
				stream[t * 3 + i] = indices[i];
		}

		// -------------------- //

		var iBuffer:ByteBuffer = BufferUtils.createByteBuffer( stream.length );
			iBuffer.put( stream, 0, stream.length );
			iBuffer.flip();

		return iBuffer;
	}

	/**
	 *
	 * @param	data
	 * @return
	 */
	private function createVertexBuffer( data:IMeshData ):FloatBuffer
	{
		var typelist:Array<RegisterType> = this.signature.toArray();

		// -------------- //

		var vertexSize:Int = 0;

		for( type in typelist )
			vertexSize += type.size;

		// -------------------- //

		var stream:NativeArray<Single> = new NativeArray<Single>( this.signature.numVertices * vertexSize );

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

		// -------------------- //

		var vBuffer:FloatBuffer = BufferUtils.createFloatBuffer( stream.length );
			vBuffer.put( stream, 0, stream.length );
			vBuffer.flip();

		return vBuffer;
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// dispose:

	/**
	 *
	 */
	public function dispose():Void
	{
		if ( this.ptr_vertexArray != -1 )
		{
			GL15.glDeleteBuffers( this.ptr_vertexArray );
			this.ptr_vertexArray = -1;
		}

		if ( this.ptr_indexBuffer != -1 )
		{
			GL15.glDeleteBuffers( this.ptr_indexBuffer );
			this.ptr_indexBuffer = -1;
		}

		if ( this.ptr_vertexBuffer != -1 )
		{
			GL15.glDeleteBuffers( this.ptr_vertexBuffer );
			this.ptr_vertexBuffer = -1;
		}
	}
}