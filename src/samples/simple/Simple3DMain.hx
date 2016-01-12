package;

import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigRequest;
import haxe.at.dotpoint.controls.InputControlSystem;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.display.IDisplayEngine;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.renderable.IRenderable;
import haxe.at.dotpoint.dot3d.bootstrapper.AMainApplication;
import haxe.at.dotpoint.dot3d.bootstrapper.IMainApplication;
import haxe.at.dotpoint.dot3d.camera.Camera;
import haxe.at.dotpoint.dot3d.camera.PerspectiveLens;
import haxe.at.dotpoint.dot3d.renderable.input.DefaultRenderInput;
import haxe.at.dotpoint.math.geom.Space;
import haxe.at.dotpoint.math.vector.Vector3;

#if(java && lwjgl)
typedef AMain3D = lwjgl.at.dotpoint.dot3d.bootstrapper.MainApplication;
#elseif flash
typedef AMain3D = flash.at.dotpoint.dot3d.bootstrapper.MainApplication;
#else
typedef AMain3D = AMainApplication<IDisplayEngine,InputControlSystem>;
#end

/**
 * ...
 * @author RK
 */
class Simple3DMain extends AMain3D implements IMainApplication
{

	/**
	 *
	 */
	private var gameLoop:SimpleGameLoop;

	/**
	 *
	 */
	private var renderList:Array<IDisplayObject>;

	/**
	 *
	 */
	private var camera:Camera;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
	 *
	 */
	public function new( ?request:BootstrapperConfigRequest )
	{
		super( request );
	}

	// ************************************************************************ //
	// Init
	// ************************************************************************ //

	/**
	 *
	 * @param	event
	 */
	override function onBootstrapperComplete( event:Event ):Void
	{
		super.onBootstrapperComplete( event );

		// -------- //

		this.initScene();
		this.initGameLoop();
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //
	// SCENE:

	/**
	 *
	 */
	private function initScene():Void
	{
		this.renderList = new Array<IDisplayObject>();

		this.camera = new Camera( new PerspectiveLens( this.displayEngine.getContext().getViewport() ) );
		this.camera.transform.position.z += 2.5;
		this.camera.transform.position.y += 0;
		this.camera.transform.position.x += 0;
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //
	// Game-Loop:

	/**
	 *
	 */
	private function initGameLoop():Void
	{
		this.gameLoop = new SimpleGameLoop();
		this.gameLoop.start( this.displayEngine, this.onTick );
	}

	// ************************************************************************ //
	// Rendering
	// ************************************************************************ //

	/**
	 *
	 */
	private function onTick():Void
	{
		var renderables:Array<IRenderable> = new Array<IRenderable>();

		for( obj in this.renderList )
		{
			var input:DefaultRenderInput = cast obj.renderable.input;

			if( input == null )
				input = new DefaultRenderInput();

			input.E_MODEL2WORLD_TRANSFORM  	= obj.transform.getMatrix( null, Space.WORLD );
			input.W_WORLD2CAMERA_TRANSFORM 	= this.camera.getProjectionMatrix();
			input.W_LIGHT_DIRECTIONAL 		= new Vector3( 1, 0, 1 );

			obj.renderable.input = input;
			renderables.push( obj.renderable );
		}

		this.displayEngine.getRenderer().render( renderables );
	}

	/**
	 *
	 */
	private function addDisplayObjectToScene( obj:IDisplayObject ):Void
	{
		this.renderList.push( obj );
		this.displayEngine.getScene().getSpatialTree().addChildNode( obj.getSpatialNode() );
	}

}