package lwjgl.at.dotpoint.dot3d.rendering.renderable;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.rendering.register.RegisterFormat;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.renderable.AMeshBuffer;
import haxe.at.dotpoint.display.rendering.renderable.IMeshBuffer;
import haxe.at.dotpoint.display.rendering.renderable.MeshBufferType;
import haxe.at.dotpoint.display.rendering.shader.IShader;
import haxe.ds.Vector;
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
class Java3DMeshBuffer extends AMeshBuffer implements IMeshBuffer
{


	/**
	 * true if the mesh buffer is currently active on the GPU (shader calls use this mesh right now)
	 */
	public var isBound(default, null):Bool;

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

		this.isBound = false;
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
		if( this.isBound )
			this.unbind();

		super.allocate( data );

		// -------------------- //

		this.allocateVertexArray();
		this.allocateVertexBuffer( data );
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
		if( this.isBound )
			this.unbind();

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
	public function bind( shader:IShader ):Void
	{
		if( !this.isAllocated )
			throw "must be allocated first";

		if( this.isBound )
			this.unbind();

		GL30.glBindVertexArray( this.ptr_vertexArray );
		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, this.ptr_vertexBuffer );

		this.setVertexAttributes( shader );

		GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, this.ptr_indexBuffer );

		this.isBound = true;
	}

	/**
	 * sets the mesh buffer as inactive on the GPU (no mesh will be active for shader calls then)
	 */
	public function unbind():Void
	{
		GL30.glBindVertexArray( 0 );
		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, 0 );
		GL15.glBindBuffer( GL15.GL_ELEMENT_ARRAY_BUFFER, 0 );

		this.isBound = false;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 * @param	data
	 */
	private function setVertexAttributes( shader:IShader ):Void
	{
		var stride:Int = RegisterHelper.getSignatureSize( this.signature ) * 4; // in effing bytes
		var offset:Int = 0;

		for ( t in 0...this.signature.numRegisters )
		{
			var register:RegisterType 	= this.signature.getRegisterTypeByIndex( t );
			var format:Int 				= this.getVertexBufferFormat( register.format );
			var location:Int 			= this.getVertexAttributeLocation( shader, register );

			GL20.glEnableVertexAttribArray( location );
			GL20.glVertexAttribPointer( location, register.size, format, false, stride, offset );

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
				throw "not a vertexbuffer format";
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

		for( j in 0...shader.getShaderSignature().numRegisters )
		{
			var sregister:RegisterType = shader.getShaderSignature().getRegisterTypeByIndex( j );

			if( sregister.ID == register.ID )
				return location;

			location += Math.ceil( sregister.size / 4 );
		}

		throw "could not find vertex attrib location";
		return -1;
	}

}