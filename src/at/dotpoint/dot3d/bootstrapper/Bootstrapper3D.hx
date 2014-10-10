package at.dotpoint.dot3D.bootstrapper;

import at.dotpoint.core.bootstrapper.Bootstrapper;
import at.dotpoint.core.event.Event;
import at.dotpoint.display.event.DisplayEvent;
import at.dotpoint.display.Stage;
import at.dotpoint.dot3d.bootstrapper.IRenderManager;
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
class Bootstrapper3D extends Bootstrapper implements IRenderManager
{

	/**
	 * 
	 */
	public var render:RenderSystem;
	
	/**
	 * 
	 */
	public var scene:Scene;	
	
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
	}
	
	/**
	 * 
	 * @param	event
	 */
	public function onEnterFrame( event:Event ):Void
	{
		this.render.update(0);
	}
}