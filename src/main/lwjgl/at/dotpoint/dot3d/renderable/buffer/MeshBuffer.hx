package lwjgl.at.dotpoint.dot3d.renderable.buffer;

import haxe.at.dotpoint.core.dispatcher.lazy.LazyStatus;
import haxe.at.dotpoint.display.renderable.mesh.buffer.AMeshBuffer;
import haxe.at.dotpoint.display.renderable.mesh.data.IMeshData;
import haxe.at.dotpoint.display.renderable.mesh.data.MeshSignature;
import haxe.at.dotpoint.display.renderable.register.RegisterHelper;
import haxe.at.dotpoint.display.renderable.register.type.RegisterFormat;
import haxe.at.dotpoint.display.renderable.register.type.RegisterType;
import haxe.at.dotpoint.display.renderable.shader.IShader;
import haxe.ds.Vector;
import lwjgl.at.dotpoint.dot3d.DisplayEngine;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import org.lwjgl.BufferUtils;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL15;
import org.lwjgl.opengl.GL20;
import org.lwjgl.opengl.GL30;

/**
 * ...
 * @author RK
 */
class MeshBuffer extends AMeshBuffer
{

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
		super();

		this.ptr_vertexArray  = -1;
		this.ptr_indexBuffer  = -1;
		this.ptr_vertexBuffer = -1;
	}

	// ************************************************************************ //
	// Allocate
	// ************************************************************************ //

	/**
	 * data mesh to upload to the GPU
	 */
	override public function allocate( data:IMeshData ):Void
	{
		this.dispose( data );

		// ---------- //

		if( this.ptr_vertexArray == -1 )
			this.allocateVertexArray();

		if( this.ptr_vertexBuffer == -1 )
			this.allocateVertexBuffer( data );

		if( this.ptr_indexBuffer == -1 )
			this.allocateIndexBuffer( data );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

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

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 * @param	data
	 * @return
	 */
	private function createIndexBuffer( data:IMeshData ):IntBuffer
	{
		var iBuffer:IntBuffer = BufferUtils.createIntBuffer( this.getIndexBufferSize( data.signature ) );

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
		var stream:Vector<Single> = new Vector<Single>( this.getVertexBufferSize( data.signature ) );

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
	 * remove the mesh data from the GPU
	 */
	override public function dispose( data:IMeshData ):Void
	{
		this.unbind( data, null );

		// ---------- //

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

	// ************************************************************************ //
	// Bind
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as currently active on the GPU (shader calls will use this allocated mesh then)
	 */
	override public function bind( data:IMeshData, shader:IShader ):Void
	{
		if( this.ptr_vertexArray != -1 )
			GL30.glBindVertexArray( this.ptr_vertexArray );

		if( this.ptr_vertexBuffer != -1 )
			GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, this.ptr_vertexBuffer );

		if( this.ptr_indexBuffer != -1 )
			GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, this.ptr_indexBuffer );

		this.setVertexAttributes( shader, data.signature );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 * @param	data
	 */
	private function setVertexAttributes( shader:IShader, signature:MeshSignature ):Void
	{
		var stride:Int = RegisterHelper.getSignatureSize( signature ) * 4; // in effing bytes
		var offset:Int = 0;

		for ( t in 0...signature.numRegisters )
		{
			var register:RegisterType 	= signature.getRegisterTypeByIndex( t );
			var format:Int 				= this.getVertexBufferFormat( register.format );
			var location:Int 			= this.getVertexAttributeLocation( shader, register );

			if( format == -1 )
				throw "not a vertexbuffer format";

			if( location > -1 )
			{
				GL20.glEnableVertexAttribArray( location );
				GL20.glVertexAttribPointer( location, register.size, format, false, stride, offset );
			}

			offset += register.size * 4;
		}
	}

	/**
	 *
	 * @param	format
	 */
	private function getVertexBufferFormat( format:RegisterFormat ):Int
	{
		switch( format )
		{
			case RegisterFormat.TFLOAT_1: 	return GL11.GL_FLOAT;
			case RegisterFormat.TFLOAT_2: 	return GL11.GL_FLOAT;
			case RegisterFormat.TFLOAT_3: 	return GL11.GL_FLOAT;
			case RegisterFormat.TFLOAT_4: 	return GL11.GL_FLOAT;
			case RegisterFormat.TINT: 		return GL11.GL_INT;

			default:
				return -1;
		}

		return GL11.GL_FLOAT;
	}

	/**
	 *
	 * @param	register
	 * @return
	 */
	private function getVertexAttributeLocation( shader:IShader, register:RegisterType ):Int
	{
		var location:Int = 0;

		for( j in 0...shader.data.signature.numRegisters )
		{
			var sregister:RegisterType = shader.data.signature.getRegisterTypeByIndex( j );

			if( sregister.ID == register.ID )
				return location;

			location += Math.ceil( sregister.size / 4 );
		}

		return -1;
	}

	// ************************************************************************ //
	// Unbind
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as inactive on the GPU (no mesh will be active for shader calls then)
	 */
	override public function unbind( data:IMeshData, shader:IShader ):Void
	{
		GL30.glBindVertexArray( 0 );
		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, 0 );
		GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, 0 );
	}

}