package at.dotpoint.dot3d.camera;

import at.dotpoint.dot3d.render.ScreenDimension;
import at.dotpoint.math.MathUtil;


/**
 * This projection allows a natural visual presentation of objects, mimicking 3D perspective
 * @author Gerald Hattensauer
 */
class PerspectiveLens extends Lens
{
	
	public var yFOV(default, set):Float;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( screen:ScreenDimension, ?yFOV:Float ) 
	{
		super( screen );
		this.yFOV = yFOV != null ? yFOV : 45 * MathUtil.DEG_RAD;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
		
	//
	private function set_yFOV( value:Float ):Float 
	{
		this.yFOV = value;
		this.invalidProjection = true;
		
		return value;
	}	
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //	
	
	/**
	 * 		
	 */
	override private function validateMatrix():Void 
	{
		var cotan:Float = 1 / Math.tan( this.yFOV * 0.5 );				
		var depth:Float = this.zNear - this.zFar;
		
		// -------------------- //
		
		this.projectionMatrix.toIdentity();
		
		this.projectionMatrix.m11 = cotan / this.screen.ratio;				
		this.projectionMatrix.m22 = cotan;									
		this.projectionMatrix.m33 = (this.zFar + this.zNear) / depth;		
		
		this.projectionMatrix.m43 = (2 * this.zFar * this.zNear) / depth;	
		this.projectionMatrix.m34 = -1;											
		this.projectionMatrix.m44 = 0;
	}

	
}