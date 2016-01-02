package;

import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.display.IDisplayEngine;

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
	public function start( engine:IDisplayEngine, onTick:Void->Void ):Void
	{
		if( this.callback != null )
			throw "already running";

		this.callback = onTick;
		this.startLoop( engine );
	}

	#if (java && lwjgl)
	//
	private function startLoop( engine:IDisplayEngine ):Void
	{
		var context:lwjgl.at.dotpoint.dot3d.rendering.RenderContext = cast engine.getContext();

		while( org.lwjgl.glfw.GLFW.glfwWindowShouldClose( context.ptr_window ) == org.lwjgl.opengl.GL11.GL_FALSE )
		{
			this.callback();
			org.lwjgl.glfw.GLFW.glfwPollEvents();
		}
	}
	#elseif flash
	//
	private function startLoop( engine:IDisplayEngine ):Void
	{
		function onEnterFrame( event:flash.events.Event ):Void
		{
			this.callback();
		}

		flash.Lib.current.addEventListener( flash.events.Event.ENTER_FRAME, onEnterFrame );
	}
	#end
}