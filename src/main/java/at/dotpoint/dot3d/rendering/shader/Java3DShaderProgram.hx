package java.at.dotpoint.dot3d.rendering.shader;

import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.shader.IShader;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL20;

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
	public var ptr_program(default, null):Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
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
	 * @param	vertex_program
	 * @param	fragment_program
	 */
	private function createShaderProgram( vertex_program:String, fragment_program:String ):Int
	{
		var vshader:Int = GL20.glCreateShader( GL20.GL_VERTEX_SHADER );

		GL20.glShaderSource( vshader, vertex_program );
		GL20.glCompileShader( vshader );

		var vstatus:Int = GL20.glGetShaderi( vshader, GL20.GL_COMPILE_STATUS );

		if( vstatus == GL11.GL_FALSE )
			throw "error compiling vertex shader: " + GL20.glGetShaderInfoLog(vshader);

		// -------- //

		var fshader:Int = GL20.glCreateShader( GL20.GL_FRAGMENT_SHADER );

		GL20.glShaderSource( fshader, fragment_program );
		GL20.glCompileShader( fshader );

		var fstatus:Int = GL20.glGetShaderi( fshader, GL20.GL_COMPILE_STATUS );

		if( fstatus == GL11.GL_FALSE )
			throw "error compiling fragment shader: " + GL20.glGetShaderInfoLog(fshader);

		// -------- //

		var program:Int = GL20.glCreateProgram();

		GL20.glAttachShader( program, vshader );
		GL20.glAttachShader( program, fshader );

		GL20.glBindAttribLocation( program, 0, "position" );
		GL20.glLinkProgram( program );

		var pstatus:Int = GL20.glGetShaderi( program, GL20.GL_LINK_STATUS );

		if( pstatus == GL11.GL_FALSE )
			throw "error linking shader program: " + GL20.glGetProgramInfoLog( program );

		GL20.glDetachShader( program, vshader );
		GL20.glDetachShader( program, fshader );

		return program;
	}
}