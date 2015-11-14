package flash.at.dotpoint.dot3d.shader;

import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShader;
import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShaderContext;
import flash.display3D.Context3DTriangleFace;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.dot3d.rendering.renderable.Texture;
import haxe.at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

class TMeshColorShader extends Shader
{
	static var SRC =
	{

		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //

		var input:
		{
			V_POSITION:Float3,
			V_NORMAL:Float3,
			V_COLOR:Float4,
		};

		var tcolor:Float4;
		var lpow:Float;

		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:

		function vertex( E_MODEL2WORLD_TRANSFORM:M44, W_WORLD2CAMERA_TRANSFORM:M44, W_LIGHT_DIRECTIONAL:Float3 )
		{
			out = input.V_POSITION.xyzw * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;
			lpow = W_LIGHT_DIRECTIONAL.dot( (input.V_NORMAL * E_MODEL2WORLD_TRANSFORM).normalize() ).max(0);
			tcolor = input.V_COLOR;
		}

		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:

		function fragment( M_TEXTURE_DIFFUSE:Texture )
		{
			out = tcolor * (lpow * 0.8 + 0.2);
		}
	};
}

/**
 * ...
 * @author RK
 */
class MeshColorShader extends Flash3DShader
{

	/**
	 *
	 */
	private var shader:TMeshColorShader;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();

		this.shader 		= new TMeshColorShader();
		this.contextSetting = new Flash3DShaderContext();
		this.signature 		= this.generateShaderSignature( "MeshColor" );

		this.contextSetting.culling = Context3DTriangleFace.NONE;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public override function getInternalShader():TMeshColorShader
	{
		return this.shader;
	}

	/**
	 *
	 * @param	type
	 * @param	data
	 */
	override public function setRegisterData( type:RegisterType, data:Dynamic ):Void
	{
		if( type.ID == RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
			this.shader.W_WORLD2CAMERA_TRANSFORM = cast data;

		if( type.ID == RegisterHelper.E_MODEL2WORLD_TRANSFORM.ID )
			this.shader.E_MODEL2WORLD_TRANSFORM = cast data;

		if( type.ID == RegisterHelper.W_LIGHT_DIRECTIONAL.ID )
		{
			if( data == null )
				data = new Vector3();

			this.shader.W_LIGHT_DIRECTIONAL = cast data;
		}
	}
}