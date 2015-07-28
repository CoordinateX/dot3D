package java.at.dotpoint.dot3d.rendering.shader;

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
	public var ptr_shader(default,null):Int;

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
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function compile():Void
	{
		if( this.ptr_shader != null )
		{
			Log.warn( "already compiled: " + Log.getCallstack() );
			this.dispose();
		}

		var vshader:Int = GL20.glCreateShader( GL20.GL_VERTEX_SHADER );

		GL20.glShaderSource( vshader, this.source );
		GL20.glCompileShader( vshader );

		var vstatus:Int = GL20.glGetShaderi( vshader, GL20.GL_COMPILE_STATUS );

		if( vstatus == GL11.GL_FALSE )
			throw "error compiling vertex shader: " + GL20.glGetShaderInfoLog(vshader);

		this.ptr_shader = vshader;
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