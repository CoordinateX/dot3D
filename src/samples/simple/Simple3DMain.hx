package;

import haxe.at.dotpoint.bootstrapper.Bootstrapper;
import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigParser.DefaultBootstrapperFactory;
import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigRequest;
import haxe.at.dotpoint.controls.InputControlSystem;
import haxe.at.dotpoint.controls.InputRequest;
import haxe.at.dotpoint.controls.InputType;
import haxe.at.dotpoint.controls.keyboard.IKeyboardInput;
import haxe.at.dotpoint.controls.keyboard.KeyboardMap;
import haxe.at.dotpoint.core.application.ApplicationInfo;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.core.processor.ITaskFactory;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.dot3d.camera.PerspectiveLens;
import haxe.at.dotpoint.dot3d.camera.Stage3DCamera;
import haxe.at.dotpoint.dot3d.controls.TransformInputControl;
import haxe.at.dotpoint.dot3d.scene.Stage3DScene;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.loader.URLRequest;
import SimpleGameLoop;

/**
 * ...
 * @author RK
 */
class Simple3DMain
{

	/**
	 *
	 */
	private var boostrapper:Bootstrapper;

	/**
	 *
	 */
	private var transformControl:TransformInputControl;

	/**
	 *
	 */
	private var gameLoop:SimpleGameLoop;

	// ---------------- //

	/**
	 *
	 */
	private var renderList:Array<IDisplayObject>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?url:String )
	{
		if( url == null )
		{
			#if flash
			url = "../../res/main/bootstrapper.cfg";
			#else
			url = "res/main/bootstrapper.cfg";
			#end
		}

		this.setupBootstrapper( url );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	private function setupBootstrapper( url:String ):Void
	{
		var factory:ITaskFactory = new DefaultBootstrapperFactory();
		var request:BootstrapperConfigRequest = new BootstrapperConfigRequest( new URLRequest( url ), factory );

		this.boostrapper = new Bootstrapper();
		this.boostrapper.processRequest( request, this.initialize );
	}

	/**
	 *
	 */
	private function initialize( event:Event ):Void
	{
		trace( ApplicationInfo.instance );

		Stage3DEngine.instance.getContext().getViewport().setDimension( 960, 540 );
		Stage3DEngine.instance.initialize( this.onContextComplete );
	}

	/**
	 *
	 * @param	event
	 */
	private function onContextComplete( event:StatusEvent ):Void
	{
		this.initScene();
		this.initController();
		this.initGameLoop();
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	private function initScene():Void
	{
		this.renderList = new Array<IDisplayObject>();

		var scene:Stage3DScene = Stage3DEngine.instance.getScene();
			scene.camera = new Stage3DCamera();

		scene.camera.transform.position.z += 3.5;
		scene.camera.transform.position.y += 1;
		scene.camera.transform.position.x += 0;
	}

	/**
	 *
	 */
	private function initController():Void
	{
		InputControlSystem.instance.initialize();
		this.transformControl = new TransformInputControl();
	}

	/**
	 *
	 */
	private function initGameLoop():Void
	{
		this.gameLoop = new SimpleGameLoop();
		this.gameLoop.start( this.onTick );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	private function onTick():Void
	{
		Stage3DEngine.instance.getRenderer().render( this.renderList );
	}

	/**
	 *
	 */
	private function addDisplayObjectToScene( obj:IDisplayObject ):Void
	{
		this.renderList.push( obj );
		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( obj.getSpatialNode() );
	}
}