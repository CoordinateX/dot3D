package at.dotpoint.dot3d;

import at.dotpoint.core.MainApplication;
import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.dot3d.loader.format.WavefrontMaterialFormat;
import at.dotpoint.dot3d.loader.format.WavefrontObjectFormat;
import at.dotpoint.loader.DataHelper;
import flash.events.Event;

import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.dot3d.camera.Camera;

/**
 * ...
 * @author RK
 */
class MainDot3D extends MainApplication
{
	
	private var renderer:RenderProcessor;
	private var scene:Scene;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new() 
	{
		super();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	override private function init():Void
	{
		DataHelper.instance.formats.push( WavefrontObjectFormat.instance );
		DataHelper.instance.formats.push( WavefrontMaterialFormat.instance );
		DataHelper.instance.formats.push( TextureFormat.instance );
		
		// --------------------------- //
		
		var viewport:Viewport = Viewport.create( this, true );		
		
		this.renderer = new RenderProcessor( viewport );
		this.renderer.init( this.onRenderInitComplete );
		
		this.scene = new Scene();
		this.scene.camera = Camera.createDefault( viewport );			
	}	
	
	/**
	 * 
	 * @param	event
	 */
	private function onRenderInitComplete( event:Event ):Void
	{					
		throw "override";
	}
	
	/**
	 * 
	 */
	private function renderScene():Void
	{
		this.renderer.render( this.scene.gatherRenderUnits() );
	}
}