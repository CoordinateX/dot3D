package;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.dot3d.Stage3DEngine;

/**
 * ...
 * @author RK
 */
class SimpleGameLoop
{

	//
	private var callback:Void->Void;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{

	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	onTick
	 */
	public function start( onTick:Void->Void ):Void
	{
		if( this.callback != null )
			throw "already running";

		this.callback = onTick;

		// ----------- //

		#if flash
		function onEnterFrame( event:flash.events.Event ):Void
		{
			this.callback();
		}

		flash.Lib.current.addEventListener( flash.events.Event.ENTER_FRAME, onEnterFrame );
		#elseif (java && lwjgl)
		while( org.lwjgl.glfw.GLFW.glfwWindowShouldClose( Stage3DEngine.instance.getContext().ptr_window ) == org.lwjgl.opengl.GL11.GL_FALSE )
		{
			this.callback();
			org.lwjgl.glfw.GLFW.glfwPollEvents();
		}
		#end
	}
}