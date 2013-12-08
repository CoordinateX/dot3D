package ;
import at.dotpoint.core.KeyInput;
import at.dotpoint.dot3d.EntityContainer;
import at.dotpoint.dot3d.transform.Position;
import at.dotpoint.dot3d.transform.Rotation;
import at.dotpoint.dot3d.transform.Scale;
import at.dotpoint.dot3d.transform.Transform;
import at.dotpoint.dot3d.Space;
import flash.ui.Keyboard;

/**
 * ...
 * @author RK
 */
class ModelController
{

	public var moveSpeed:Float = 1.;
	public var rotateSpeed:Float = 0.025;
	
	
	public function new() 
	{
		KeyInput.initialize();
	}
	
	/**
	 * 
	 */
	public function update( container:EntityContainer ):Void
	{
		var transform:Transform 	= container.getTransform( Space.WorldSpace );
		
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
		
		// ---------------------------- //			
	}
}