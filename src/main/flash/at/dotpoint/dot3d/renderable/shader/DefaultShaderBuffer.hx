package flash.at.dotpoint.dot3d.renderable.shader;

import flash.at.dotpoint.dot3d.renderable.buffer.ShaderBuffer;
import flash.display3D.Context3D;
import haxe.at.dotpoint.display.renderable.register.RegisterHelper;
import haxe.at.dotpoint.display.renderable.register.type.RegisterType;
import haxe.at.dotpoint.math.vector.Matrix44;
import haxe.at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

/**
 * ...
 * @author RK
 */
class DefaultShaderBuffer extends ShaderBuffer<HaxeShader>
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( context:Context3D )
	{
		super( context, new HaxeShader() );
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
		if( type.ID == RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
		{
			var value:Matrix44 = new Matrix44();
				value.setArray( data );

			this.shader.W_WORLD2CAMERA_TRANSFORM = value;
		}

		if( type.ID == RegisterHelper.E_MODEL2WORLD_TRANSFORM.ID )
		{
			var value:Matrix44 = new Matrix44();
				value.setArray( data );

			this.shader.E_MODEL2WORLD_TRANSFORM = value;
		}

		if( type.ID == RegisterHelper.W_LIGHT_DIRECTIONAL.ID )
		{
			var value:Vector3 = new Vector3();
				value.set( data[0], data[1], data[2] );

			this.shader.W_LIGHT_DIRECTIONAL = value;
		}

		if( type.ID == RegisterHelper.M_COLOR.ID )
		{
			var value:Vector3 = new Vector3();
				value.set( data[0], data[1], data[2] );

			this.shader.M_COLOR = value;
		}
	}
}


/**
 *
 */
class HaxeShader extends Shader
{
	static var SRC =
	{

		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //

		var input:
		{
			V_POSITION:Float3,
			V_NORMAL:Float3,
		};

		var lpow:Float;

		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:

		function vertex( E_MODEL2WORLD_TRANSFORM:M44, W_WORLD2CAMERA_TRANSFORM:M44, W_LIGHT_DIRECTIONAL:Float3 )
		{
			out = input.V_POSITION.xyzw * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;
			lpow = W_LIGHT_DIRECTIONAL.dot( (input.V_NORMAL * E_MODEL2WORLD_TRANSFORM).normalize() ).max(0);
		}

		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:

		function fragment( M_COLOR:Float4 )
		{
			out = M_COLOR * (lpow * 0.8 + 0.2);
		}
	};
}