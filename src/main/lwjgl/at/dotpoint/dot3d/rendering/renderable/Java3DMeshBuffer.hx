package lwjgl.at.dotpoint.dot3d.rendering.renderable;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshSignature;
import haxe.at.dotpoint.display.rendering.register.RegisterFormat;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.renderable.AMeshBuffer;
import haxe.at.dotpoint.display.rendering.renderable.IMeshBuffer;
import haxe.at.dotpoint.display.rendering.renderable.MeshBufferType;
import haxe.at.dotpoint.logger.Log;
import haxe.ds.Vector;
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
import java.nio.IntBuffer;

/**
 * ...
 * @author RK
 */
class Java3DMeshBuffer extends AMeshBuffer implements IMeshBuffer
{


	/**
	 * true if the mesh buffer is currently active on the GPU (shader calls use this mesh right now)
	 */
	public var isBound(get, null):Bool;

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

	public function new( ?storageType:MeshBufferType )
	{
		super( storageType );

		this.ptr_vertexArray  = -1;
		this.ptr_indexBuffer  = -1;
		this.ptr_vertexBuffer = -1;
	}

	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //

	private function get_isBound():Bool
	{
		return false;
	}

	// ************************************************************************ //
	// allocate
	// ************************************************************************ //

	/**
	 *
	 * @param	context
	 * @param	mesh
	 */
	override public function allocate( data:IMeshData ):Void
	{
		super.allocate( data );

		// -------------------- //

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
	private function createIndexBuffer( data:IMeshData ):IntBuffer
	{
		var iBuffer:IntBuffer = BufferUtils.createIntBuffer( this.getIndexBufferSize() );

		function setStreamData( index:Int, value:Int ):Void
		{
			iBuffer.put( value );
		}

		this.populateIndexStream( data, setStreamData );

		// -------------------- //

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
		var stream:Vector<Single> = new Vector<Single>( this.getVertexBufferSize() );

		function setStreamData( index:Int, value:Float ):Void
		{
			stream[index] = value;
		}

		this.populateVertexStream( data, setStreamData );

		// -------------------- //

		var vBuffer:FloatBuffer = BufferUtils.createFloatBuffer( stream.length );
			vBuffer.put( cast stream, 0, stream.length );
			vBuffer.flip();

		return vBuffer;
	}

	// ************************************************************************ //
	// dispose
	// ************************************************************************ //

	/**
	 *
	 */
	override public function dispose():Void
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

		// -------------------- //

		super.dispose();
	}

	// ************************************************************************ //
	// bind/unbinds
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as currently active on the GPU (shader calls will use this allocated mesh then)
	 */
	public function bind():Void
	{
		return;
	}

	/**
	 * sets the mesh buffer as inactive on the GPU (no mesh will be active for shader calls then)
	 */
	public function unbind():Void
	{
		return;
	}
}