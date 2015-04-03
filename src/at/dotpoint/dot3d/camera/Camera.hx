package at.dotpoint.dot3d.camera;

import at.dotpoint.core.evaluate.event.EvaluateEvent;
import at.dotpoint.core.dispatcher.event.Event;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.dot3d.render.ScreenDimension;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.Matrix44;

/**
 * A virtual camera used to render through. Depending on the Lens chosen it projects the visible
 * scene perspectivly or orthographic and so on. The Camera can be moved and rotated through the 
 * world like a normal scene entity.
 * 
 * @author Gerald Hattensauer
 */
class Camera extends DisplayObject
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
		this.lense.addListener( EvaluateEvent.CHANGED, this.onMatrixChanged );
		
		this.transformations.addListener( EvaluateEvent.CHANGED, this.onTransformChanged );
		
		this.projectionMatrix = new Matrix44();
		this.invalidMatrix = true;
	}
	
	/**
	 * creates a camera with a normal perspecive lense
	 */
	public static function createDefault( viewport:ScreenDimension ):Camera
	{
		return new Camera( new PerspectiveLens( viewport ) );
	}
	
	/**
	 * creates a camera with a normal orthographic lense using the aspect ratio of the screen
	 */
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
	private function onTransformChanged( event:Event ):Void
	{
		this.invalidMatrix = true;
	}
	
	// lense changed
	private function onMatrixChanged( event:Event ):Void
	{
		this.invalidMatrix = true;
		
		//if ( this.hasListener( EntityEvent.PROJECTION_CHANGED ) )
		//	this.dispatch( new EntityEvent( EntityEvent.PROJECTION_CHANGED ) );
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	//
	private function validate():Void
	{
		Matrix44.multiply( this.lense.getProjectionMatrix(), this.getTransform( Space.WORLD ).getMatrix(), this.projectionMatrix );
		this.invalidMatrix = false;
	}
		
}