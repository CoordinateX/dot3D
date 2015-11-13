package flash.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.core.dispatcher.event.EventDispatcher;
import haxe.at.dotpoint.core.dispatcher.event.generic.ErrorEvent;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.core.dispatcher.lazy.event.LazyEvent;
import haxe.at.dotpoint.display.event.DisplayEvent;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.context.IRenderContext;
import haxe.at.dotpoint.display.rendering.context.RenderSettings;
import haxe.at.dotpoint.display.rendering.context.RenderViewport;
import haxe.at.dotpoint.display.scene.IScene;
import haxe.at.dotpoint.logger.Log;
import haxe.at.dotpoint.math.color.ColorFormat;
import haxe.at.dotpoint.math.color.ColorUtil;
import flash.display.Stage;
import flash.display3D.Context3D;
import flash.Lib;

/**
 * ...
 * @author RK
 */
class Flash3DContext extends EventDispatcher implements IRenderContext
{

	/**
	 *
	 */
	private var viewport:RenderViewport;

	/**
	 *
	 */
	private var settings:RenderSettings;

	// ----------- //

	/**
	 *
	 */
	public var context3D(default, null):Context3D;

	/**
	 *
	 */
	public var stage:Stage;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();

		this.viewport = new RenderViewport();
		this.settings = new RenderSettings();
	}

	// ************************************************************************ //
	// getter/setter
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public function getViewport():RenderViewport
	{
		return this.viewport;
	}

	/**
	 *
	 * @return
	 */
	public function getSettings():RenderSettings
	{
		return this.settings;
	}

	/**
	 *
	 * @return
	 */
	public function isInitialized():Bool
	{
		return this.context3D != null;
	}

	// ************************************************************************ //
	// Initialize
	// ************************************************************************ //

	/**
	 *
	 */
	public function initialize( onComplete:StatusEvent->Void ):Void
	{
		if( onComplete != null )
			this.addListener( StatusEvent.COMPLETE, cast onComplete );

		// ------------ //

		if( Lib.current.stage == null )
		{
			Lib.current.addEventListener( flash.events.Event.ADDED_TO_STAGE, this.onStageAvaible );
		}
		else
		{
			this.onStageAvaible( null );
		}
	}

	/**
	 *
	 */
	private function onStageAvaible( ?event:flash.events.Event ):Void
	{
		if( event != null )
			event.target.removeEventListener( event, this.onStageAvaible );

		// ------------ //

		this.stage = cast Lib.current.stage;
		this.getStageData();

		this.viewport.addListener( DisplayEvent.VIEWPORT_RESIZE, this.setStageData );
		this.settings.addListener( LazyEvent.CHANGED, this.setStageData );

		// ------------ //

		this.stage.stage3Ds[0].addEventListener( flash.events.Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.stage.stage3Ds[0].addEventListener( flash.events.ErrorEvent.ERROR, this.onContextCreationError );
		this.stage.stage3Ds[0].requestContext3D();


	}

	/**
	 *
	 * @param	event
	 */
	private function onContextCreated( ?event:flash.events.Event ):Void
	{
		this.context3D = this.stage.stage3Ds[0].context3D;

		#if debug
			this.context3D.enableErrorChecking = true;
		#end

		this.stage.stage3Ds[0].removeEventListener( flash.events.Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.stage.stage3Ds[0].removeEventListener( flash.events.ErrorEvent.ERROR, this.onContextCreationError );

		// --------------- //

		this.setStageData();

		if( this.hasListener( StatusEvent.COMPLETE ) )
			this.dispatch( new StatusEvent( StatusEvent.COMPLETE ) );
	}

	/**
	 *
	 * @param	event
	 */
	private function onContextCreationError( ?event:flash.events.ErrorEvent ):Void
	{
		this.dispatch( ErrorEvent.fromEvent( event ) );
	}

	// ----------------------------------------- //
	// ----------------------------------------- //
	// StageData

	/**
	 *
	 */
	private function getStageData():Void
	{
		this.viewport.setDimension( this.stage.stageWidth, this.stage.stageHeight );

		this.settings.frameRate         = Std.int( this.stage.frameRate );
		this.settings.colorBackground   = ColorUtil.toVector( this.stage.color, ColorFormat.RGB );
	}

	/**
	 *
	 */
	private function setStageData( ?event:Event ):Void
	{
		if( this.context3D != null )
			this.context3D.configureBackBuffer( this.viewport.width, this.viewport.height, 0, true );

		// -------- //

		this.stage.frameRate = this.settings.frameRate;
		this.stage.color     = ColorUtil.toInt( this.settings.colorBackground, ColorFormat.RGB );

		if( this.stage.stageWidth  != this.viewport.width
		||  this.stage.stageHeight != this.viewport.height )
		{
			Log.warn( "Internal Stage-Dimension cannot be set to Viewport-Dimension" );
		}
	}

}