package flash;

import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.at.dotpoint.core.KeyInput;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.math.Axis;
import haxe.at.dotpoint.math.MathUtil;
import haxe.at.dotpoint.math.vector.IQuaternion;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Quaternion;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.at.dotpoint.spatial.ISpatialEntity;
import haxe.at.dotpoint.spatial.transform.ITransform;
import haxe.at.dotpoint.spatial.transform.Transform;

/**
 * ...
 * @author RK
 */
class ModelController
{

	public var moveSpeed:Float = 0.05;
	public var rotateSpeed:Float = 1 * MathUtil.DEG_RAD;

	public var isKeyDown:Bool;

	public function new()
	{
		KeyInput.initialize();

		Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKey );
        Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP, onKey );
	}

	private function onKey( event:KeyboardEvent ):Void
	{
		this.isKeyDown = event.type == KeyboardEvent.KEY_DOWN;
	}

	/**
	 *
	 */
	public function update( transform:ITransform ):Void
	{
		// ---------------------------- //
		// translation

		if ( !KeyInput.isDown( Keyboard.SHIFT ) )
		{
			if ( KeyInput.isDown( Keyboard.W ) )
				this.appendTranslation( Axis.Z, -this.moveSpeed, transform );

			if ( KeyInput.isDown( Keyboard.S ) )
				this.appendTranslation( Axis.Z,  this.moveSpeed, transform );

			if ( KeyInput.isDown( Keyboard.A ) )
				this.appendTranslation( Axis.X, -this.moveSpeed, transform );

			if ( KeyInput.isDown( Keyboard.D ) )
				this.appendTranslation( Axis.X,  this.moveSpeed, transform );

			if ( KeyInput.isDown( Keyboard.R ) )
				this.appendTranslation( Axis.Y,  this.moveSpeed, transform );

			if ( KeyInput.isDown( Keyboard.F ) )
				this.appendTranslation( Axis.Y, -this.moveSpeed, transform );
		}

		// ---------------------------- //
		// rotation

		if ( KeyInput.isDown( Keyboard.SHIFT ) )
		{
			if ( KeyInput.isDown( Keyboard.W ) )
				this.appendRotation( Axis.X,  this.rotateSpeed, transform );

			if ( KeyInput.isDown( Keyboard.S ) )
				this.appendRotation( Axis.X, -this.rotateSpeed, transform );

			if ( KeyInput.isDown( Keyboard.A ) )
				this.appendRotation( Axis.Y, -this.rotateSpeed, transform );

			if ( KeyInput.isDown( Keyboard.D ) )
				this.appendRotation( Axis.Y,  this.rotateSpeed, transform );

			if ( KeyInput.isDown( Keyboard.Q ) || KeyInput.isDown( Keyboard.R ) )
				this.appendRotation( Axis.Z,  this.rotateSpeed, transform );

			if ( KeyInput.isDown( Keyboard.E ) || KeyInput.isDown( Keyboard.F ) )
				this.appendRotation( Axis.Z, -this.rotateSpeed, transform );
		}
	}

	/**
	 *
	 * @param	axis
	 * @param	distance
	 * @param	transform
	 */
	private function appendTranslation( axis:Axis, distance:Float, transform:ITransform ):Void
	{
		var origin:IQuaternion = transform.rotation;

		var vector:IVector3 = Quaternion.getAxis( origin, axis );
			vector = Vector3.scale( vector, distance, vector );

		Vector3.add( transform.position, vector, transform.position );
	}

	/**
	 *
	 * @param	axis
	 * @param	radians
	 */
	private function appendRotation( axis:Axis, radians:Float, transform:ITransform ):Void
	{
		var origin:IQuaternion = transform.rotation;
		var vector:IVector3 = Quaternion.getAxis( origin, axis );

		var rotation:Quaternion = Quaternion.setAxisAngle( vector, radians, new Quaternion() );
			rotation.normalize();

		var new_rotation:Quaternion = Quaternion.multiply( origin, rotation, new Quaternion() );
			new_rotation.normalize();

		new_rotation.clone( origin );
	}
}