package at.dotpoint.dot3D.bootstrapper;

import at.dotpoint.core.bootstrapper.Bootstrapper;
import at.dotpoint.core.event.Event;
import at.dotpoint.display.event.DisplayEvent;
import at.dotpoint.display.Stage;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.scene.Scene;
import flash.display.Stage3D;
import flash.Lib;

/**
 * ...
 * @author RK
 */
class Bootstrapper3D extends Bootstrapper
{

	/**
	 * 
	 */
	private var renderer:RenderProcessor;
	
	/**
	 * 
	 */
	private var scene:Scene;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		super();		
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	override function initialize():Void 
	{
		super.initialize();
		
		this.initializeRenderer();
		this.initializeScene();
	}
	
	/**
	 * 
	 */
	private function initializeRenderer():Void
	{
		var stage:Stage3D = Lib.current.stage.stage3Ds[0];		
		var viewport:Viewport = new Viewport( stage, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight );		
		
		this.renderer = new RenderProcessor( viewport );
		this.renderer.init( this.onRenderInitComplete );
	}
	
	/**
	 * 
	 */
	private function initializeScene():Void
	{		
		this.scene = new Scene();
		this.scene.camera = Camera.createDefault( this.renderer.viewport );
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onRenderInitComplete( event:Event ):Void
	{					
		Stage.instance.addEventListener( DisplayEvent.ENTER_FRAME, this.onEnterFrame );	
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.renderScene();
	}
	
	/**
	 * 
	 */
	private function renderScene():Void
	{
		this.renderer.render( this.scene.gatherRenderUnits() );
	}
}