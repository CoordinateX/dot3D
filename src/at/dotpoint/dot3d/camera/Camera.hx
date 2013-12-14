package at.dotpoint.dot3d.camera;

import at.dotpoint.dot3d.EntityContainer;
import at.dotpoint.dot3d.render.ScreenDimension;
import at.dotpoint.math.vector.Matrix44;
import flash.events.Event;

/**
 * ...
 * @author Gerald Hattensauer
 */
class Camera extends EntityContainer
{

	private var projectionMatrix:Matrix44;
	private var invalidMatrix:Bool;
	
	public var lense:Lens;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( projection:Lens ) 
	{
		super();
		
		this.lense = projection;	
		this.lense.addEventListener( Event.CHANGE, this.onMatrixChanged, false, 0, true );
		
		this.projectionMatrix = new Matrix44();
		this.invalidMatrix = true;
	}
	
	public static function createDefault( viewport:ScreenDimension ):Camera
	{
		return new Camera( new PerspectiveLens( viewport ) );
	}
	
	public static function createOrthographic( ratio:Float ):Camera
	{
		var h:Int = 2;
		var w:Int = Std.int( h * ratio );
		
		return new Camera( new OrtographicLens(  new ScreenDimension( w, h ) ) );
	}
	
	// ************************************************************************ //
	// Methode
	// ************************************************************************ //	
	
	/**
	 * combination of camera transformation and projection of lense
	 * @return
	 */
	public function getProjectionMatrix():Matrix44
	{
		if ( this.invalidMatrix )
			this.validate();
		
		return this.projectionMatrix;
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	// position/scale/rotation of the cam changed
	override private function onTransformChanged( event:Event ):Void
	{
		super.onTransformChanged( event );
		this.invalidMatrix = true;
	}
	
	// lense changed
	private function onMatrixChanged( event:Event ):Void
	{
		this.invalidMatrix = true;
		
		//if ( this.hasEventListener( EntityEvent.PROJECTION_CHANGED ) )
		//	this.dispatchEvent( new EntityEvent( EntityEvent.PROJECTION_CHANGED ) );
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	//
	private function validate():Void
	{
		Matrix44.multiply( this.lense.getProjectionMatrix(), this.getTransform( Space.WorldSpace ).getMatrix(), this.projectionMatrix );	
		this.invalidMatrix = false;
	}
		
}