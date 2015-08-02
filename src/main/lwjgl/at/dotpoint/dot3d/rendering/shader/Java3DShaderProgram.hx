package lwjgl.at.dotpoint.dot3d.rendering.shader;

import format.abc.Data.Register;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.shader.IShader;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.logger.Log;
import haxe.at.dotpoint.math.vector.Vector3;
import java.NativeArray;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL20;
import org.lwjgl.BufferUtils;
import java.nio.FloatBuffer;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/**
 * ...
 * @author RK
 */
class Java3DShaderProgram implements IShader
{

	/**
	 *
	 */
	private var signature:ShaderSignature;

	/**
	 *
	 */
	public var vertexShader(default,null):Java3DShader;

	/**
	 *
	 */
	public var fragmentShader(default,null):Java3DShader;

	/**
	 *
	 */
	public var ptr_program(default, null):Int;

	/**
	 *
	 */
	public var isCompiled(get,null):Bool;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( vertexShader:Java3DShader, fragmentShader:Java3DShader )
	{
		this.vertexShader = vertexShader;
		this.fragmentShader = fragmentShader;

		if( this.vertexShader.type != Java3DShaderType.VERTEX_SHADER )
			throw "vertex shader is not marked as type: VertexShader";

		if( this.fragmentShader.type != Java3DShaderType.FRAGMENT_SHADER )
			throw "vertex shader is not marked as type: FragmentShader";

		this.ptr_program = -1;
	}

	// ************************************************************************ //
	// IShader
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public function getShaderSignature():ShaderSignature
	{
		return this.signature;
	}

	/**
	 *
	 * @param	type
	 * @param	data
	 */
	public function getRegisterData<T:Dynamic>( type:RegisterType ):T
	{
		return null;
	}

	/**
	 *
	 * @param	type
	 * @param	data
	 */
	public function setRegisterData( type:RegisterType, data:Dynamic ):Void
	{
		return;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	private function get_isCompiled():Bool
	{
		return this.ptr_program != -1;
	}

	/**
	 *
	 * @param	vertex_program
	 * @param	fragment_program
	 */
	public function compile():Void
	{
		if( this.isCompiled )
		{
			Log.warn( "already compiled: " + Log.getCallstack() );
			this.dispose();
		}

		// -------- //

		if(!this.vertexShader.isCompiled )
			this.vertexShader.compile();

		if(!this.fragmentShader.isCompiled )
			this.fragmentShader.compile();

		// -------- //

		var program:Int = GL20.glCreateProgram();

		GL20.glAttachShader( program, this.vertexShader.ptr_shader );
		GL20.glAttachShader( program, this.fragmentShader.ptr_shader );

		this.bindAttributeLocations( program );
		GL20.glLinkProgram( program );

		var pstatus:Int = GL20.glGetShaderi( program, GL20.GL_LINK_STATUS );

		if( pstatus == GL11.GL_FALSE )
			throw "error linking shader program: " + GL20.glGetProgramInfoLog( program );

		GL20.glDetachShader( program, this.vertexShader.ptr_shader );
		GL20.glDetachShader( program, this.fragmentShader.ptr_shader );

		// -------- //

		this.ptr_program = program;
	}

	/**
	 *
	 * @param	program
	 */
	private function bindAttributeLocations( program:Int ):Void
	{
		var location:Int = 0;

		for( j in 0...this.signature.numRegisters )
		{
			var register:RegisterType = this.signature.getRegisterTypeByIndex( j );

			trace("bind: to location: " + location + " --- " + register );
			GL20.glBindAttribLocation( program, location, register.ID );

			location += Math.ceil( register.size / 4 );
		}
	}

	public function dispose():Void
	{
		return;
	}

	private function setUniformValue( type:RegisterType, value:Array<Float>, index:Int ):Void
	{
		var location:Int =  GL20.glGetUniformLocation( this.ptr_program, type.ID );

		trace( "set location: " + location + " --- " + type );

		switch( value.length )
		{
			case 2:		GL20.glUniform2f( location, value[0], value[1] );
			case 3:		GL20.glUniform3f( location, value[0], value[1], value[2] );
			case 4:		GL20.glUniform4f( location, value[0], value[1], value[2], value[3] );

			case 16:
			{
				var bbuffer:ByteBuffer = BufferUtils.createByteBuffer( value.length * 4 );

				for( j in 0...value.length )
					bbuffer.putFloat( value[j] );

				bbuffer.flip();

				GL20.glUniformMatrix4fv( location, 1, false, bbuffer );
			}
		}
	}
}