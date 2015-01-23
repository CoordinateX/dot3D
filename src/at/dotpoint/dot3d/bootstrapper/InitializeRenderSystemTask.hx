package at.dotpoint.dot3d.bootstrapper;

import at.dotpoint.core.dispatcher.event.Event;
import at.dotpoint.core.dispatcher.event.EventDispatcher;
import at.dotpoint.core.processor.event.ProcessEvent;
import at.dotpoint.core.processor.ITask;
import at.dotpoint.display.event.DisplayEvent;
import at.dotpoint.display.Stage;
import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.RenderSystem;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.Vector3;
import flash.display.Stage3D;
import flash.Lib;
import at.dotpoint.dot3d.camera.Camera;

/**
 * ...
 * @author RK
 */
class InitializeRenderSystemTask extends EventDispatcher implements ITask
{

	/**
	 * 
	 */
	public var renderManager:IRenderManager;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( manager:IRenderManager ) 
	{
		super();
		this.renderManager = manager;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	public function execute():Void 
	{
		this.dispatch( new ProcessEvent( ProcessEvent.TASK_STARTED ) );	
		
		this.initializeScene();
		this.initializeRenderer();	
	}
	/**
	 * 
	 */
	private function initializeScene():Void
	{		
		this.renderManager.scene = new Scene();
		this.renderManager.scene.camera = Camera.createDefault( this.createViewport() );
		this.renderManager.scene.camera.getTransform( Space.WORLD ).position.z -= 10;
		
		var t:Float = Math.random();
		
		this.renderManager.scene.light = new Vector3( Math.cos(t * 10) * 1, Math.sin(t * 5) * 2, Math.sin(t) * Math.cos(t) * 2);
		this.renderManager.scene.light.normalize();
	}
	
	/**
	 * 
	 */
	private function initializeRenderer():Void
	{
		var viewport:Viewport = this.createViewport();	
		
		this.renderManager.render = new RenderSystem( new RenderProcessor( viewport ), this.renderManager.scene );		
		this.renderManager.render.renderer.init( this.onRenderInitComplete );
	}
	
	// --------------------------- //
	// --------------------------- //
	
	/**
	 * 
	 * @return
	 */
	private function createViewport():Viewport
	{
		var stage:Stage3D = Lib.current.stage.stage3Ds[0];		
		var viewport:Viewport = new Viewport( stage, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight );	
		
		return viewport;
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onRenderInitComplete( event:Event ):Void
	{					
		Stage.instance.addListener( DisplayEvent.ENTER_FRAME, this.renderManager.onEnterFrame );
		this.clear();
	}
	
	// -------------------------------------------------------- //
	// -------------------------------------------------------- //
	
	/**
	 * 
	 */
	public function clear():Void 
	{
		this.dispatch( new ProcessEvent( ProcessEvent.TASK_COMPLETE ) );
	}
}