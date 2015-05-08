package;

import at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import at.dotpoint.display.DisplayEngine;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.display.geometry.Model;
import at.dotpoint.display.IDisplayObject;
import at.dotpoint.display.rendering.shader.ShaderSignature;
import at.dotpoint.display.Sprite;
import at.dotpoint.dot2d.scene.Stage2DScene;
import at.dotpoint.dot2d.Stage2DEngine;
import at.dotpoint.dot3d.camera.PerspectiveLens;
import at.dotpoint.dot3d.camera.Stage3DCamera;
import at.dotpoint.dot3d.geometry.material.DiffuseColorMaterial;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Cube.CubeMesh;
import at.dotpoint.dot3d.render.Stage3DContext;
import at.dotpoint.dot3d.render.Stage3DRenderer;
import at.dotpoint.dot3d.scene.Stage3DScene;
import at.dotpoint.dot3d.Stage3DEngine;
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
	private var cube2D:Cube;
	private var cube3D:Cube;
	
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
		Stage2DEngine.instance.initialize( this.onContextComplete );
		Stage3DEngine.instance.initialize( this.onContextComplete );
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onContextComplete( event:StatusEvent ):Void
	{
		if( !Stage2DEngine.instance.isInitialized() )	return;
		if( !Stage3DEngine.instance.isInitialized() )	return;
		
		// ------------------------- //
		
		this.init2D();
		this.init3D();
		
		Lib.current.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
	}
	
	/**
	 * 
	 */
	private function init2D():Void
	{
		var scene:Stage2DScene = cast Stage2DEngine.instance.getScene();
		
		// ------------- //
		
		this.cube2D = new Cube( 60, 60, 60 );
		this.cube2D.transform.position.x += 100;
		this.cube2D.transform.position.y += 100;
		
		Stage2DEngine.instance.getScene().getSpatialTree().addChildNode( cube2D.getSpatialNode() );
	}
	
	/**
	 * 
	 */
	private function init3D():Void
	{
		var scene:Stage3DScene = cast Stage3DEngine.instance.getScene();
			scene.camera = this.camera = new Stage3DCamera( new PerspectiveLens( Stage3DEngine.instance.getContext().getViewport() ) );				
		
		this.camera.transform.position.x += 0.5;	
		
		this.controller = new ModelController();	
		
		// --------------- //
		
		this.cube3D = new Cube();
		this.cube3D.transform.position.z -= 6;
		
		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( cube3D.getSpatialNode() );
	}

	
	/**
	 * 
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.controller.update( this.cube2D );
		this.controller.update( this.cube3D );
		
		Stage2DEngine.instance.getRenderer().render( [this.cube2D] );
		Stage3DEngine.instance.getRenderer().render( [this.cube3D] );
	}
}

