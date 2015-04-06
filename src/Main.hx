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

/**
 * ...
 * @author RK
 */
class Main
{
	
	private static var instance:Main;
	
	// ---------------- //
	
	
	
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
			scene.camera = new Stage3DCamera( new PerspectiveLens( DisplayEngine.renderer.getContext().getViewport() ) );
		
		var cube:IDisplayObject = cast new DisplayObject( new CubeMesh( 1, 1, 1 ), new DiffuseColorMaterial() );
			cube.transform.position.z = 0;
		
		scene.getSpatialTree().addChildNode( cube.getSpatialNode() );
		
		DisplayEngine.renderer.render( [cube] );
		
		trace("done");
	}
}

