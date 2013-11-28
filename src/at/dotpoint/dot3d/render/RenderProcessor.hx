package at.dotpoint.dot3d.render;

import flash.display3D.Context3D;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * ...
 * @author RK
 */
class RenderProcessor extends EventDispatcher
{

	public var viewport(default,null):Viewport;	
	public var context(default,null):Context3D;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( viewport:Viewport, ?onComplete:Event->Void ) 
	{
		super();
		
		this.viewport = viewport;		
		
		if ( onComplete != null )
		{		
			this.addEventListener( Event.COMPLETE, onComplete, false, 0, true  );
			this.init();
		}
	}
	
	/**
	 * 
	 */
	public function init():Void
	{
		if ( this.context != null )
		{
			trace( "already initialized" );
			return;
		}
		
		this.viewport.stage3D.addEventListener( Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.viewport.stage3D.addEventListener( ErrorEvent.ERROR, this.onContextCreationError );
		
		this.viewport.stage3D.requestContext3D();
	}
	
	// ************************************************************************ //
	// Setup
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function onContextCreated( event:Event ):Void
	{
		this.context = this.stage.context3D;		
		this.context.configureBackBuffer( this.viewport.width, this.viewport.height, 0, true );	
		
		#if debug
			this.context.enableErrorChecking = true; 
		#end 
		
		this.viewport.stage3D.removeEventListener( Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.viewport.stage3D.removeEventListener( ErrorEvent.ERROR, this.onContextCreationError );
		
		this.dispatchEvent( new Event( Event.COMPLETE ) );
	}
	
	/**
	 * 
	 */
	private function onContextCreationError( event:ErrorEvent ):Void 
	{
		throw "unknown stage3D error; ID: " +  event.errorID;
	}
	
	// ************************************************************************ //
	// Rendering
	// ************************************************************************ //	
	
	
	
}