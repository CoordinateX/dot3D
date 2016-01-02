package;

import haxe.at.dotpoint.bootstrapper.loader.BootstrapperConfigRequest;
import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.dot3d.primitives.Plane;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.loader.DataRequest;
import haxe.at.dotpoint.loader.event.DataLoaderEvent;

/**
 * ...
 * @author RK
 */
class MainIsometric extends Simple3DMain
{

	/**
	 *
	 */
	private static var instance:MainIsometric;

	// ----------------- //

	/**
	 *
	 */
	private var request:DataRequest;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		MainIsometric.instance = new MainIsometric();
	}

	public function new()
	{
		if( MainIsometric.instance == null )
			MainIsometric.instance= this;

		#if flash
			super( "../../res/main/bootstrapper.cfg");
		#else
			super();
		#end
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	request
	 */
	override function startBootstrapper( request:BootstrapperConfigRequest ):Void
	{
		this.boostrapper.addListener( DataLoaderEvent.ITEM_COMPLETE, this.onItemComplete );
		super.startBootstrapper(request);
	}

	/**
	 *
	 */
	private function onItemComplete( value:Event ):Void
	{
		var event:DataLoaderEvent = cast value;

		trace( event.result );
	}

	/**
	 *
	 */
	override function initScene():Void
	{
		super.initScene();

		// ---------- //

		var ground:Plane = new Plane();

		this.addDisplayObjectToScene( ground );
	}

	/**
	 *
	 */
	override function onTick():Void
	{
		this.transformControl.update( Stage3DEngine.instance.getScene().camera.transform );
		super.onTick();
	}
}