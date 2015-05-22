package haxe;

import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.at.dotpoint.core.KeyInput;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.math.MathUtil;
import haxe.at.dotpoint.math.vector.IQuaternion;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Quaternion;
import haxe.at.dotpoint.math.vector.Vector3;

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
	public function update( camera:IDisplayObject ):Void
	{
		var position:IVector3 		= camera.transform.position;
		var rotation:IQuaternion	= camera.transform.rotation;
		var scale:IVector3 			= camera.transform.scale;
		
		// ---------------------------- //
		// translation
		
		if ( !KeyInput.isDown( Keyboard.SHIFT ) )
		{
			if ( KeyInput.isDown( Keyboard.W ) )
				position.y += this.moveSpeed;
			
			if ( KeyInput.isDown( Keyboard.S ) )
				position.y -= this.moveSpeed;
			
			if ( KeyInput.isDown( Keyboard.A ) )
				position.x -= this.moveSpeed;
			
			if ( KeyInput.isDown( Keyboard.D ) )
				position.x += this.moveSpeed;
			
			if ( KeyInput.isDown( Keyboard.R ) )
				position.z -= this.moveSpeed;
			
			if ( KeyInput.isDown( Keyboard.F ) )
				position.z += this.moveSpeed;
		}		
		
		// ---------------------------- //
		// rotation	
		
		if ( KeyInput.isDown( Keyboard.SHIFT ) )
		{
			if ( KeyInput.isDown( Keyboard.W ) )
				this.appendRotation( new Vector3( 1, 0, 0 ),  this.rotateSpeed, rotation );
			
			if ( KeyInput.isDown( Keyboard.S ) )
				this.appendRotation( new Vector3( 1, 0, 0 ), -this.rotateSpeed, rotation );
			
			if ( KeyInput.isDown( Keyboard.A ) )
				this.appendRotation( new Vector3( 0, 0, 1 ),  this.rotateSpeed, rotation );
			
			if ( KeyInput.isDown( Keyboard.D ) )
				this.appendRotation( new Vector3( 0, 0, 1 ), -this.rotateSpeed, rotation );
			
			if ( KeyInput.isDown( Keyboard.R ) )
				this.appendRotation( new Vector3( 0, 1, 0 ),  this.rotateSpeed, rotation );
			
			if ( KeyInput.isDown( Keyboard.F ) )
				this.appendRotation( new Vector3( 0, 1, 0 ), -this.rotateSpeed, rotation );
		}
	}
	
	/**
	 * 
	 * @param	axis
	 * @param	radians
	 */
	private function appendRotation( axis:Vector3, radians:Float, origin:IQuaternion ):Void 
	{
		var rotation:Quaternion = Quaternion.setAxisAngle( axis, radians, new Quaternion() );
			rotation.normalize();
			
		var new_rotation:Quaternion = Quaternion.multiply( origin, rotation, new Quaternion() );
			new_rotation.normalize();
		
		new_rotation.clone( origin );
	}
}