package haxe.at.dotpoint.dot3d.bootstrapper;

import haxe.at.dotpoint.bootstrapper.BootstrapperTask;
import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigRequest;
import haxe.at.dotpoint.controls.bootstrapper.InputControlTask;
import haxe.at.dotpoint.controls.IInputControlSystem;
import haxe.at.dotpoint.core.application.bootstrapper.ApplicationInfoTask;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.core.processor.event.ProcessEvent;
import haxe.at.dotpoint.core.processor.ITask;
import haxe.at.dotpoint.core.processor.ITaskFactory;
import haxe.at.dotpoint.display.IDisplayEngine;
import haxe.at.dotpoint.display.bootstrapper.DisplayEngineTask;
import haxe.at.dotpoint.loader.URLRequest;

/**
 * ...
 * @author RK
 */
class Bootstrapper extends haxe.at.dotpoint.bootstrapper.Bootstrapper
{

	/**
	 *
	 */
	public var mainApplication:IMainApplication;

	/**
	 *
	 */
	public var taskFactory:ITaskFactory;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( mainApplication:IMainApplication, ?taskFactory:ITaskFactory )
	{
		super();

		this.mainApplication = mainApplication;
		this.taskFactory = taskFactory;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	url
	 * @param	onComplete
	 */
	public function processURL( url:String, ?onComplete:Event->Void ):Void
	{
		var factory:ITaskFactory = this.taskFactory;

		if( factory == null )
			factory = new BootstrapperTaskFactory();

		this.processRequest( new BootstrapperConfigRequest( new URLRequest( url ), factory ), onComplete );
	}

	/**
	 *
	 * @param	request
	 * @param	onComplete
	 */
	public override function processRequest( request:BootstrapperConfigRequest, ?onComplete:Event->Void ):Void
	{
		if( request.factory == null )
			request.factory = this.taskFactory != null ? this.taskFactory : new BootstrapperTaskFactory();

		this.addListener( ProcessEvent.TASK_STARTED,  this.onProcessEvent );
		this.addListener( ProcessEvent.TASK_COMPLETE, this.onProcessEvent );

		super.processRequest( request, onComplete );
	}

	/**
	 *
	 * @param	value
	 */
	private function onProcessEvent( value:Event ):Void
	{
		var event:ProcessEvent = cast value;

		if( Std.is( event.task, BootstrapperTask ) )
		{
			switch( event.type )
			{
				case ProcessEvent.TASK_STARTED:
					this.onBootTaskStarted( event, cast event.task );

				case ProcessEvent.TASK_COMPLETE:
					this.onBootTaskComplete( event, cast event.task );

				default:
					return;
			}
		}
	}

	/**
	 *
	 * @param	value
	 */
	private function onBootTaskStarted( event:ProcessEvent, task:BootstrapperTask<Dynamic> ):Void
	{
		switch( task.name )
		{
			case InputControlTask.ID:
				cast( task, InputControlTask ).inputController = this.mainApplication.getInputControlSystem();

			case DisplayEngineTask.ID:
				cast( task, DisplayEngineTask ).displayEngine = this.mainApplication.getDisplayEngine();
		}
	}

	/**
	 *
	 * @param	value
	 */
	private function onBootTaskComplete( event:ProcessEvent, task:BootstrapperTask<Dynamic> ):Void
	{
		//;
	}

}

/**
 * ...
 * @author RK
 */
class BootstrapperTaskFactory implements ITaskFactory
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{

	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	id
	 * @param	data
	 * @return
	 */
	public function createTask( id:String, data:Dynamic ):ITask
	{
		switch( id )
		{
			case ApplicationInfoTask.ID:
				return new ApplicationInfoTask( data );

			case InputControlTask.ID:
				return new InputControlTask( data );

			case DisplayEngineTask.ID:
				return new DisplayEngineTask( data );

			default:
				throw "unsupported task: " + id;
		}

		return null;
	}
}