package lwjgl.at.dotpoint.dot3d.renderable.buffer;

import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.renderable.input.IRenderInput;
import haxe.at.dotpoint.display.renderable.register.type.RegisterContext;
import haxe.at.dotpoint.display.renderable.register.type.RegisterType;
import haxe.at.dotpoint.display.renderable.shader.buffer.AShaderBuffer;
import haxe.at.dotpoint.display.renderable.shader.buffer.IShaderBuffer;
import haxe.at.dotpoint.display.renderable.shader.data.AShaderData;
import haxe.at.dotpoint.display.renderable.shader.data.IShaderData;
import haxe.at.dotpoint.display.renderable.shader.data.ShaderSignature;
import haxe.at.dotpoint.logger.Log;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL20;
import org.lwjgl.BufferUtils;
import java.nio.FloatBuffer;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/**
 * ...
 */
class ShaderBuffer extends AShaderBuffer
{

	/**
	 *
	 */
	@:isVar public var vertexShader(get,set):GLShader;

	/**
	 *
	 */
	@:isVar public var fragmentShader(get,set):GLShader;

	/**
	 *
	 */
	public var ptr_program(default, null):Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
	 *
	 * @param	vertex
	 * @param	fragment
	 */
	public function new( ?vertex:GLShader, ?fragment:GLShader )
	{
		super();

		this.vertexShader = vertex;
		this.fragmentShader = fragment;

		this.ptr_program = -1;
	}

	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	private function get_vertexShader():GLShader { return this.vertexShader; }

	private function set_vertexShader( value:GLShader ):GLShader
	{
		if( value != null && value.type != GLShaderType.VERTEX_SHADER )
			throw "given GLShader is not of type vertex shader";

		return this.vertexShader = value;
	}

	/**
	 *
	 * @return
	 */
	private function get_fragmentShader():GLShader { return this.fragmentShader; }

	private function set_fragmentShader( value:GLShader ):GLShader
	{
		if( value != null && value.type != GLShaderType.FRAGMENT_SHADER )
			throw "given GLShader is not of type fragment shader";

		return this.fragmentShader = value;
	}

	// ************************************************************************ //
	// Allocate
	// ************************************************************************ //

	/**
	 * data mesh to upload to the GPU
	 */
	override public function allocate( data:IShaderData ):Void
	{
		this.dispose( data );

		// ------------- //

		this.compileGLShader();
		this.compileProgram( data );
	}

	/**
	 *
	 */
	private function compileGLShader():Void
	{
		if( this.vertexShader == null )
			throw "vertex shader not set (null)";

		if( this.fragmentShader == null )
			throw "vertex shader not set (null)";

		this.vertexShader.compile();
		this.fragmentShader.compile();
	}

	/**
	 *
	 */
	private function compileProgram( data:IShaderData ):Void
	{
		this.ptr_program = GL20.glCreateProgram();

		GL20.glAttachShader( this.ptr_program, this.vertexShader.ptr_shader );
		GL20.glAttachShader( this.ptr_program, this.fragmentShader.ptr_shader );

		this.setAttributeLocations( data.signature );
		this.linkProgram();

		GL20.glDetachShader( this.ptr_program, this.vertexShader.ptr_shader );
		GL20.glDetachShader( this.ptr_program, this.fragmentShader.ptr_shader );
	}

	/**
	 *
	 */
	private function linkProgram():Void
	{
		GL20.glLinkProgram( this.ptr_program );

		if( GL20.glGetShaderi( this.ptr_program, GL20.GL_LINK_STATUS ) == GL11.GL_FALSE )
			throw "error linking shader program: " + GL20.glGetProgramInfoLog( this.ptr_program );
	}

	/**
	 *
	 * @param	program
	 */
	private function setAttributeLocations( signature:ShaderSignature ):Void
	{
		var location:Int = 0;

		for( j in 0...signature.numRegisters )
		{
			var register:RegisterType = signature.getRegisterTypeByIndex( j );

			GL20.glBindAttribLocation( this.ptr_program, location, register.ID );
			location += Math.ceil( register.size / 4 );
		}
	}

	// ************************************************************************ //
	// Dispose
	// ************************************************************************ //

	/**
	 * remove the mesh data from the GPU
	 */
	override public function dispose( data:IShaderData ):Void
	{
		if( this.vertexShader != null && this.vertexShader.ptr_shader != -1 )
			GL20.glDetachShader( this.ptr_program, this.vertexShader.ptr_shader );

		if( this.fragmentShader != null && this.fragmentShader.ptr_shader != -1 )
			GL20.glDetachShader( this.ptr_program, this.fragmentShader.ptr_shader );

		if( this.ptr_program != -1 )
			GL20.glDeleteProgram( this.ptr_program );
	}

	// ************************************************************************ //
	// Bind
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as currently active on the GPU (shader calls will use this allocated mesh then)
	 */
	override public function bind( data:IShaderData, input:IRenderInput ):Void
	{
		GL20.glUseProgram( this.ptr_program );
		this.setRegisterInputData( data, input );
	}

	/**
	 * sets the mesh buffer as inactive on the GPU (no mesh will be active for shader calls then)
	 */
	override public function unbind( data:IShaderData, input:IRenderInput ):Void
	{
		GL20.glUseProgram( 0 );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	type
	 * @param	data
	 */
	override public function setRegisterData( type:RegisterType, data:Array<Float> ):Void
	{
		var location:Int = GL20.glGetUniformLocation( this.ptr_program, type.ID );

		if( location <= -1 )
			throw "uniform-location " + type.ID + " not found on shader";

		switch( data.length )
		{
			case 2:		GL20.glUniform2f( location, data[0], data[1] );
			case 3:		GL20.glUniform3f( location, data[0], data[1], data[2] );
			case 4:		GL20.glUniform4f( location, data[0], data[1], data[2], data[3] );

			case 16:
			{
				var bbuffer:ByteBuffer = BufferUtils.createByteBuffer( data.length * 4 );

				for( j in 0...data.length )
					bbuffer.putFloat( data[j] );

				bbuffer.flip();

				GL20.glUniformMatrix4fv( location, 1, false, bbuffer );
			}
		}
	}
}

/**
 * ...
 */
class GLShader
{

	/**
	 *
	 */
	public var source:String;

	/**
	 *
	 */
	public var type:GLShaderType;

	/**
	 *
	 */
	public var ptr_shader(default, null):Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( source:String, type:GLShaderType )
	{
		this.ptr_shader = -1;

		this.source = source;
		this.type = type;
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 */
	public function compile():Void
	{
		this.dispose();

		// ------------- //

		this.ptr_shader = GL20.glCreateShader( this.getGLShaderType() );

		GL20.glShaderSource( this.ptr_shader, this.source );
		GL20.glCompileShader( this.ptr_shader );

		// ------------- //

		if( GL20.glGetShaderi( this.ptr_shader, GL20.GL_COMPILE_STATUS ) == GL11.GL_FALSE )
			throw "error compiling shader: " + GL20.glGetShaderInfoLog( this.ptr_shader );
	}

	/**
	 *
	 */
	public function dispose():Void
	{
		if( this.ptr_shader != -1 )
			GL20.glDeleteShader( this.ptr_shader );
	}

	/**
	 *
	 * @return
	 */
	private function getGLShaderType():Int
	{
		switch( this.type )
		{
			case GLShaderType.VERTEX_SHADER: 	return GL20.GL_VERTEX_SHADER;
			case GLShaderType.FRAGMENT_SHADER: 	return GL20.GL_FRAGMENT_SHADER;
		}

		return -1;
	}
}

/**
 *
 */
enum GLShaderType
{
	VERTEX_SHADER;
	FRAGMENT_SHADER;
}