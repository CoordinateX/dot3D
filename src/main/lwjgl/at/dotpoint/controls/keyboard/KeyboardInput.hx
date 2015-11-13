package lwjgl.at.dotpoint.controls.keyboard;

import haxe.at.dotpoint.controls.keyboard.AKeyboardInput;
import haxe.at.dotpoint.controls.keyboard.KeyStatus;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import org.lwjgl.glfw.GLFW;
import java.lang.Long;

/**
 * ...
 * @author RK
 */
class KeyboardInput extends AKeyboardInput
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();

		var window:Long = Stage3DEngine.instance.getContext().ptr_window;
		var callback:KeyboardInputCallback = new KeyboardInputCallback( this );

		GLFW.glfwSetKeyCallback( window, callback );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	window
	 * @param	key
	 * @param	scancode
	 * @param	action
	 * @param	mods
	 */
	public function invoke( key:Int, scancode:Int, action:Int, mods:Int ):Void
	{
		switch( action )
		{
			case GLFW.GLFW_PRESS:
				this.keyStatusMap.set( key, KeyStatus.DOWN );

			case GLFW.GLFW_RELEASE:
				this.keyStatusMap.set( key, KeyStatus.UP );

			case GLFW.GLFW_REPEAT:
				this.keyStatusMap.set( key, KeyStatus.REPEAT );
		}
	}
}