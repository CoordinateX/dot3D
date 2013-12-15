package at.dotpoint.dot3d.camera;

import at.dotpoint.dot3d.render.ScreenDimension;

/**
 * this projection does not affect the depth and can be used for an isometric effect
 * @author Gerald Hattensauer
 */
class OrtographicLens extends Lens
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( screen:ScreenDimension ) 
	{
		super( screen );
	}
	
	/**
	 * 		
	 */
	override private function validateMatrix():Void 
	{
		var l:Float = -this.screen.width2;
		var r:Float =  this.screen.width2;
		var t:Float =  this.screen.height2;
		var b:Float = -this.screen.height2;
		
		var f:Float = this.zFar;
		var n:Float = this.zNear;
		
		// -------------- //
		
		this.projectionMatrix.toIdentity();
		
		this.projectionMatrix.m11 = 2 / (r-l);				
		this.projectionMatrix.m22 = 2 / (t-b);									
		this.projectionMatrix.m33 = -( 2 / (f-n) );		
		this.projectionMatrix.m44 = 1;		
		
		this.projectionMatrix.m41 = -( (r+l)/(r-l) );	
		this.projectionMatrix.m42 = -( (t+b)/(t-b) );									
		this.projectionMatrix.m43 = -( (f+n)/(f-n) );									
	
	}
}