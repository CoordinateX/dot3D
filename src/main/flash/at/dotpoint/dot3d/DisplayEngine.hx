package flash.at.dotpoint.dot3d;

import flash.at.dotpoint.dot3d.rendering.RenderContext;
import flash.at.dotpoint.dot3d.rendering.Renderer;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.core.dispatcher.event.IEventDispatcher;
import haxe.at.dotpoint.display.ADisplayEngine;
import haxe.at.dotpoint.display.IDisplayEngine;
import haxe.at.dotpoint.display.renderable.RenderableFactory;
import haxe.at.dotpoint.dot3d.scene.Scene;

/**
 * ...
 * @author RK
 */
class DisplayEngine extends ADisplayEngine<Renderer,RenderContext,Scene> implements IDisplayEngine
{

// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?proxy:IEventDispatcher )
	{
		super( proxy );

		this.renderer 	= new Renderer( this );
		this.context 	= new RenderContext();
		this.scene 		= new Scene();
	}

	// ************************************************************************ //
	// Initialize
	// ************************************************************************ //

	/**
	 *
	 * @param	onComplete
	 */
	override public function initialize( onComplete:StatusEvent->Void ):Void
	{
		super.initialize( onComplete );
	}

	/**
	 *
	 */
	override private function createRenderableFactory():RenderableFactory
	{
		return new flash.at.dotpoint.dot3d.renderable.RenderableFactory( this );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	override public function toString():String
	{
		return "[DisplayEngine:flash]";
	}

}