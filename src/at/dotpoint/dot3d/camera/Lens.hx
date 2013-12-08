package at.dotpoint.dot3d.camera;

import at.dotpoint.dot3d.render.ScreenDimension;
import at.dotpoint.math.vector.Matrix44;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * ...
 * @author Gerald Hattensauer
 */

class Lens extends EventDispatcher
{

	public var screen(default, set):ScreenDimension;	
	
	public var zNear(default, set):Float;
	public var zFar(default, set):Float;
	
	private var projectionMatrix:Matrix44;
	private var invalidProjection:Bool;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( screen:ScreenDimension ) 
	{		
		super();
		
		this.screen = screen;		
		this.projectionMatrix = new Matrix44();		
		
		this.zNear = 1;
		this.zFar = 100;
	}
	
	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //	
	
	//
	private function set_screen( value:ScreenDimension ):ScreenDimension 
	{
		if ( this.screen != null )
			this.screen.removeEventListener( Event.RESIZE, this.onScreenChanged );
		
		this.screen = value;
		this.screen.addEventListener( Event.RESIZE, this.onScreenChanged, false, 0, true );
		
		this.setDirty();
		
		return value;
	}
	
	//
	private function set_zNear( value:Float ):Float 
	{
		this.zNear = value;
		this.setDirty();
		
		return value;
	}
	
	//
	private function set_zFar( value:Float ):Float 
	{
		this.zFar = value;
		this.setDirty();
		
		return value;
	}
	
	/**
	 * projection matrix; validates in case it was invalidated
	 */
	public function getProjectionMatrix():Matrix44
	{
		if ( this.invalidProjection )
			this.validate();
		
		return this.projectionMatrix;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	?event
	 */
	private function onScreenChanged( event:Event ):Void 
	{
		this.setDirty();
	}	
	
	/**
	 * 
	 */
	private function validate():Void
	{		
		this.validateMatrix();
		this.validateFrustum();
		
		this.invalidProjection = false;
	}
	
	/**
	 * 
	 */
	private function validateMatrix():Void
	{
		return;
	}
	
	/**
	 * 
	 */
	private function validateFrustum():Void
	{
		return;
	}
	
	/**
	 * 
	 */
	private function setDirty():Void 
	{
		this.invalidProjection = true;
		
		if ( this.hasEventListener( Event.CHANGE ) )
			this.dispatchEvent( new Event( Event.CHANGE ) );
	}
	
}