package at.dotpoint.dot3d.bootstrapper;

import at.dotpoint.core.event.IEventDispatcher;
import at.dotpoint.dot3d.render.RenderSystem;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.core.event.Event;

/**
 * @author RK
 */

interface IRenderManager
{
  	/**
	 * 
	 */
	public var render:RenderSystem;
	
	/**
	 * 
	 */
	public var scene:Scene;
	
	/**
	 * 
	 * @param	event
	 */
	public function onEnterFrame( event:Event ):Void;
}