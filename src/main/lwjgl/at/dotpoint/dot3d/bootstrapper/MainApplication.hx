package lwjgl.at.dotpoint.dot3d.bootstrapper;

import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigRequest;
import haxe.at.dotpoint.controls.InputControlSystem;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.dot3d.bootstrapper.AMainApplication;
import haxe.at.dotpoint.dot3d.bootstrapper.Bootstrapper;
import haxe.at.dotpoint.dot3d.bootstrapper.IMainApplication;
import haxe.at.dotpoint.loader.URLRequest;
import lwjgl.at.dotpoint.controls.keyboard.KeyboardInput;
import lwjgl.at.dotpoint.dot3d.DisplayEngine;

/**
 * ...
 * @author RK
 */
class MainApplication extends AMainApplication<DisplayEngine,InputControlSystem> implements IMainApplication
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?request:BootstrapperConfigRequest )
	{
		super( request );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override function initialize( ?request:BootstrapperConfigRequest ):Void
	{
		this.displayEngine 		= new DisplayEngine();
		this.inputControlSystem = new InputControlSystem();
		this.boostrapper 		= new Bootstrapper( this );

		// ---------- //

		if( request == null )
			request = new BootstrapperConfigRequest( new URLRequest( "res/main/bootstrapper.cfg" )  );

		super.initialize( request );
	}

	/**
	 *
	 * @param	value
	 */
	override function onBootstrapperComplete( value:Event ):Void
	{
		var keyboard:KeyboardInput = new KeyboardInput( this.displayEngine.getContext().ptr_window );
			keyboard.initialize();

		this.inputControlSystem.keyboardInput = keyboard;
	}
}