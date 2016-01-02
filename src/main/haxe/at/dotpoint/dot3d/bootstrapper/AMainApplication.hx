package haxe.at.dotpoint.dot3d.bootstrapper;

import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigRequest;
import haxe.at.dotpoint.controls.IInputControlSystem;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.core.processor.event.ProcessEvent;
import haxe.at.dotpoint.display.IDisplayEngine;
import haxe.at.dotpoint.loader.URLRequest;

/**
 * ...
 * @author RK
 */
class AMainApplication<TDisplayEngine:IDisplayEngine, TInputControlSystem:IInputControlSystem>
{

	/**
	 *
	 */
	private var displayEngine:TDisplayEngine;

	/**
	 *
	 */
	private var inputControlSystem:TInputControlSystem;

	// ------------- //

	/**
	 *
	 */
	private var boostrapper:Bootstrapper;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
	 *
	 */
	public function new( ?request:BootstrapperConfigRequest )
	{
		this.initialize( request );
	}

	// ************************************************************************ //
	// Init
	// ************************************************************************ //

	/**
	 *
	 */
	private function initialize( ?request:BootstrapperConfigRequest ):Void
	{
		if( request != null ) 	this.boostrapper.processRequest( request, this.onBootstrapperComplete );
		else					this.onBootstrapperComplete( null );
	}

	/**
	 *
	 * @param	value
	 */
	private function onBootstrapperComplete( value:Event ):Void
	{
		return;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public function getDisplayEngine():TDisplayEngine
	{
		return this.displayEngine;
	}

	/**
	 *
	 * @return
	 */
	public function getInputControlSystem():TInputControlSystem
	{
		return this.inputControlSystem;
	}

}