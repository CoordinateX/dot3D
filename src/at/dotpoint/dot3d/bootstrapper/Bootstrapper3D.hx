package at.dotpoint.dot3D.bootstrapper;

import at.dotpoint.core.bootstrapper.Bootstrapper;
import at.dotpoint.core.event.Event;
import at.dotpoint.display.event.DisplayEvent;
import at.dotpoint.display.Stage;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.dot3d.loader.format.WavefrontMaterialFormat;
import at.dotpoint.dot3d.loader.format.WavefrontObjectFormat;
import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.RenderSystem;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.loader.DataHelper;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.Vector3;
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
	private var render:RenderSystem;
	
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
		
		DataHelper.instance.formats.push( WavefrontObjectFormat.instance );
		DataHelper.instance.formats.push( WavefrontMaterialFormat.instance );
		DataHelper.instance.formats.push( TextureFormat.instance );			
		
		this.initializeScene();
		this.initializeRenderer();		
	}
	
	/**
	 * 
	 */
	private function initializeRenderer():Void
	{
		var viewport:Viewport = this.createViewport();	
		
		this.render = new RenderSystem( new RenderProcessor( viewport ), this.scene );		
		this.render.renderer.init( this.onRenderInitComplete );
	}
	
	/**
	 * 
	 */
	private function initializeScene():Void
	{		
		this.scene = new Scene();
		this.scene.camera = Camera.createDefault( this.createViewport() );
		this.scene.camera.getTransform( Space.WORLD ).position.z -= 10;
		
		var t:Float = Math.random();
		
		this.scene.light = new Vector3( Math.cos(t * 10) * 1, Math.sin(t * 5) * 2, Math.sin(t) * Math.cos(t) * 2);
		this.scene.light.normalize();
	}
	
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
		Stage.instance.addEventListener( DisplayEvent.ENTER_FRAME, this.onEnterFrame );
	}

	/**
	 * 
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.render.update(0);
	}
}