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
import haxe.at.dotpoint.dot3d.camera.PerspectiveLens;
import haxe.at.dotpoint.dot3d.camera.Stage3DCamera;
import haxe.at.dotpoint.dot3d.controls.TransformInputControl;
import haxe.at.dotpoint.dot3d.scene.Stage3DScene;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.loader.URLRequest;

/**
 * ...
 * @author RK
 */
class MainGerstner
{

	/**
	 *
	 */
	private static var instance:MainGerstner;

	// ---------------- //

	/**
	 *
	 */
	private var boostrapper:Bootstrapper;

	/**
	 *
	 */
	private var transformControl:TransformInputControl;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		MainGerstner.instance = new MainGerstner();
	}

	public function new()
	{
		if( MainGerstner.instance == null )
			MainGerstner.instance= this;

		// ----------------------- //

		var factory:ITaskFactory = new DefaultBootstrapperFactory();
		var request:BootstrapperConfigRequest = new BootstrapperConfigRequest( new URLRequest( "res/main/bootstrapper.cfg" ), factory );

		this.boostrapper = new Bootstrapper();
		this.boostrapper.processRequest( request, this.initialize );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

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
	}

	/**
	 *
	 */
	private function initScene():Void
	{
		var scene:Stage3DScene = Stage3DEngine.instance.getScene();
			scene.camera = new Stage3DCamera();

		scene.camera.transform.position.z += 4;
		scene.camera.transform.position.y += 0;
		scene.camera.transform.position.x += 0;
	}

	/**
	 *
	 */
	private function initController():Void
	{
		InputControlSystem.instance.initialize();

		this.transformControl = new TransformInputControl();

		#if java
		while( org.lwjgl.glfw.GLFW.glfwWindowShouldClose( Stage3DEngine.instance.getContext().ptr_window ) == org.lwjgl.opengl.GL11.GL_FALSE )
		{
			this.transformControl.update( Stage3DEngine.instance.getScene().camera.transform );
			org.lwjgl.glfw.GLFW.glfwPollEvents();
		}
		#end
	}
}