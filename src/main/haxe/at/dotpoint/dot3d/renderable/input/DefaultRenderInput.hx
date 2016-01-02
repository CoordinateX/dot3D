package haxe.at.dotpoint.dot3d.renderable.input;

import haxe.at.dotpoint.display.renderable.input.ARenderInput;
import haxe.at.dotpoint.display.renderable.register.RegisterHelper;
import haxe.at.dotpoint.display.renderable.register.RegisterSignature;
import haxe.at.dotpoint.display.renderable.register.type.RegisterType;
import haxe.at.dotpoint.math.vector.IMatrix44;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Matrix44;
import haxe.at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class DefaultRenderInput extends ARenderInput
{

	public var W_WORLD2CAMERA_TRANSFORM:IMatrix44;
	public var E_MODEL2WORLD_TRANSFORM:IMatrix44;
	public var W_LIGHT_DIRECTIONAL:Vector3;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * returns a current list of RegisterTypes used, number of (unique) vertices and triangles
	 */
	override private function calculateSignature():RegisterSignature
	{
		var signature:RegisterSignature = new RegisterSignature(3);
			signature.addRegisterType( RegisterHelper.W_WORLD2CAMERA_TRANSFORM );
			signature.addRegisterType( RegisterHelper.E_MODEL2WORLD_TRANSFORM );
			signature.addRegisterType( RegisterHelper.W_LIGHT_DIRECTIONAL );

		return signature;
	}

	/**
	 *
	 * @param	type
	 * @return
	 */
	override public function getRegisterData( type:RegisterType ):Array<Float>
	{
		if( type.ID == RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
			return this.W_WORLD2CAMERA_TRANSFORM.getArray();

		if( type.ID == RegisterHelper.E_MODEL2WORLD_TRANSFORM.ID )
			return this.E_MODEL2WORLD_TRANSFORM.getArray();

		if( type.ID == RegisterHelper.W_LIGHT_DIRECTIONAL.ID )
			return this.W_LIGHT_DIRECTIONAL.toArray(false);


		return null;
	}
}