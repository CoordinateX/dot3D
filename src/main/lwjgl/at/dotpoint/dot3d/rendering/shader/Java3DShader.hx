package lwjgl.at.dotpoint.dot3d.rendering.shader;

import haxe.at.dotpoint.logger.Log;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL20;

/**
 * ...
 * @author RK
 */
class Java3DShader
{

	/**
	 *
	 */
	private var source:String;

	/**
	 *
	 */
	public var type:Java3DShaderType;

	/**
	 *
	 */
	public var ptr_shader(default, null):Int;

	/**
	 *
	 */
	public var isCompiled(get,null):Bool;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( source:String, type:Java3DShaderType )
	{
		this.source = source;
		this.type = type;

		this.ptr_shader = -1;
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	private function get_isCompiled():Bool
	{
		return this.ptr_shader != -1;
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// allocate

	/**
	 *
	 */
	public function compile():Void
	{
		if( this.isCompiled )
		{
			Log.warn( "already compiled: " + Log.getCallstack() );
			this.dispose();
		}

		var shader:Int = GL20.glCreateShader( this.getGLShaderType() );

		GL20.glShaderSource( shader, this.source );
		GL20.glCompileShader( shader );

		var status:Int = GL20.glGetShaderi( shader, GL20.GL_COMPILE_STATUS );

		if( status == GL11.GL_FALSE )
			throw "error compiling vertex shader: " + GL20.glGetShaderInfoLog( shader );

		this.ptr_shader = shader;
	}

	/**
	 *
	 */
	public function dispose():Void
	{
		return;
	}

	/**
	 *
	 * @return
	 */
	private function getGLShaderType():Int
	{
		switch( this.type )
		{
			case Java3DShaderType.VERTEX_SHADER: 	return GL20.GL_VERTEX_SHADER;
			case Java3DShaderType.FRAGMENT_SHADER: 	return GL20.GL_FRAGMENT_SHADER;
		}

		return -1;
	}
}