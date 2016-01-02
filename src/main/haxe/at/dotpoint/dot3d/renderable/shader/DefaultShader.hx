package haxe.at.dotpoint.dot3d.renderable.shader;

import haxe.at.dotpoint.display.renderable.register.RegisterHelper;
import haxe.at.dotpoint.display.renderable.shader.AShader;
import haxe.at.dotpoint.display.renderable.shader.buffer.IShaderBuffer;
import haxe.at.dotpoint.display.renderable.shader.data.IShaderData;
import haxe.at.dotpoint.display.renderable.shader.data.AShaderData;
import haxe.at.dotpoint.display.renderable.shader.data.ShaderSignature;

/**
 * ...
 * @author RK
 */
class DefaultShader extends AShader
{
	//
	public static var NAME(default, null):String = "default";

	//
	public function new()
	{
		super( new DefaultShaderData( DefaultShader.NAME ) );
	}

}

/**
 * ...
 * @author RK
 */
class DefaultShaderData extends AShaderData
{

	//
	public function new( name:String )
	{
		super( name );
	}

	/**
	 * returns a current list of RegisterTypes used, number of (unique) vertices and triangles
	 */
	override private function calculateSignature():ShaderSignature
	{
		var signature:ShaderSignature = new ShaderSignature( 7 );
			signature.addRegisterType( RegisterHelper.V_POSITION );
			signature.addRegisterType( RegisterHelper.V_UV_COORDINATES );
			signature.addRegisterType( RegisterHelper.V_NORMAL );
			signature.addRegisterType( RegisterHelper.M_COLOR );
			signature.addRegisterType( RegisterHelper.E_MODEL2WORLD_TRANSFORM );
			signature.addRegisterType( RegisterHelper.W_WORLD2CAMERA_TRANSFORM );
			signature.addRegisterType( RegisterHelper.W_LIGHT_DIRECTIONAL );

		return signature;
	}

}