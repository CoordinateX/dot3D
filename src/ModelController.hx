package ;

import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.core.KeyInput;
import at.dotpoint.display.components.transform.Position;
import at.dotpoint.display.components.transform.Rotation;
import at.dotpoint.display.components.transform.Scale;
import at.dotpoint.display.components.transform.Transform;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.math.geom.Space;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author RK
 */
class ModelController
{

	public var moveSpeed:Float = 1.;
	public var rotateSpeed:Float = 0.025;
	
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
	public function update( container:DisplayObject ):Void
	{
		var transform:Transform 	= container.getTransform( Space.WORLD );
		
		var position:Position 		= transform.position;
		var rotation:Rotation 		= transform.rotation;
		var scale:Scale 			= transform.scale;
		
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
				rotation.pitch( this.rotateSpeed );
			
			if ( KeyInput.isDown( Keyboard.S ) )
				rotation.pitch( -this.rotateSpeed );
			
			if ( KeyInput.isDown( Keyboard.A ) )
				rotation.roll( this.rotateSpeed );
			
			if ( KeyInput.isDown( Keyboard.D ) )
				rotation.roll( -this.rotateSpeed );
			
			if ( KeyInput.isDown( Keyboard.R ) )
				rotation.yaw( this.rotateSpeed );
			
			if ( KeyInput.isDown( Keyboard.F ) )
				rotation.yaw( -this.rotateSpeed );
		}

	}
}