package;

import at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import at.dotpoint.display.DisplayEngine;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.display.IDisplayObject;
import at.dotpoint.dot3d.camera.PerspectiveLens;
import at.dotpoint.dot3d.camera.Stage3DCamera;
import at.dotpoint.dot3d.geometry.material.DiffuseColorMaterial;
import at.dotpoint.dot3d.primitives.Cube.CubeMesh;
import at.dotpoint.dot3d.render.renderable.Stage3DRenderableFactory;
import at.dotpoint.dot3d.render.Stage3DContext;
import at.dotpoint.dot3d.render.Stage3DRenderer;
import at.dotpoint.dot3d.scene.Stage3DScene;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author RK
 */
class Main
{
	
	private static var instance:Main;
	
	// ---------------- //
	
	/**
	 * 
	 */
	private var controller:ModelController;
	
	/**
	 * 
	 */
	private var camera:Stage3DCamera;
	
	/**
	 * 
	 */
	private var cube:IDisplayObject;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	static public function main() 
	{                
		Main.instance = new Main();
	}        
	
	public function new() 
	{
		this.initialize();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	private function initialize():Void
	{
		DisplayEngine.factory = new DisplayObjectFactory( new Stage3DRenderableFactory() );
		DisplayEngine.renderer = new Stage3DRenderer( new Stage3DContext(), new Stage3DScene() );
		
		DisplayEngine.renderer.getContext().initialize( this.onContextComplete );
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onContextComplete( event:StatusEvent ):Void
	{
		var scene:Stage3DScene = cast DisplayEngine.renderer.getScene();
			scene.camera = this.camera = new Stage3DCamera( new PerspectiveLens( DisplayEngine.renderer.getContext().getViewport() ) );				
		
		//this.camera.transform.position.z -= 10.5;	
			
		this.controller = new ModelController();	
		this.createCube();
		
		Lib.current.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
	}
	
	private function createCube():Void
	{
		this.cube = cast new DisplayObject( new CubeMesh( 1, 1, 1 ), new DiffuseColorMaterial() );
		this.cube.transform.position.z -= 6;
		
		DisplayEngine.renderer.getScene().getSpatialTree().addChildNode( cube.getSpatialNode() );
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.controller.update( this.cube );
		
		DisplayEngine.renderer.render( [this.cube] );
	}
}

