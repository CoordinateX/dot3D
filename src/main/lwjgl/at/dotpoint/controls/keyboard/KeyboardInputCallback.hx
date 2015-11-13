package lwjgl.at.dotpoint.controls.keyboard;

import haxe.Int64;
import org.lwjgl.glfw.GLFWKeyCallback;
import org.lwjgl.glfw.GLFW;

/**
 *
 */
class KeyboardInputCallback extends GLFWKeyCallback
{
	//
	private var input:KeyboardInput;

	//
	public function new( input:KeyboardInput )
	{
		super();
		this.input = input;
	}

	/**
	 *
	 * @param	window
	 * @param	key
	 * @param	scancode
	 * @param	action
	 * @param	mods
	 */
	@:overload
	//
	override public function invoke( window:Int64, key:Int, scancode:Int, action:Int, mods:Int ):Void
	{
		this.input.invoke( key, scancode, action, mods );
	}
}