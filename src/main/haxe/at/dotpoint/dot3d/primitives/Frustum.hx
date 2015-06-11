package haxe.at.dotpoint.dot3d.primitives;

import haxe.at.dotpoint.display.camera.CameraComponent;
import haxe.at.dotpoint.display.camera.ICameraLens;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.dot3d.camera.PerspectiveLens;
import haxe.at.dotpoint.dot3d.renderable.Shape;

/**
 * ...
 * @author RK
 */
class Frustum extends Shape
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( lens:ICameraLens, ?color:Array<Float> ) 
	{
		super();
		this.draw( lens, color );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	

	/**
	 * 
	 * @param	lens
	 */
	private function draw( lens:ICameraLens, ?color:Array<Float> ):Void
	{		
		if( Std.is( lens, PerspectiveLens ) )
			this.drawPerspective( cast lens, color );				
	}
	
	/**
	 * 
	 * @param	lens
	 * @param	color
	 */
	public function drawPerspective( lens:PerspectiveLens, ?color:Array<Float> ):Void
	{
		var c:Array<Float> = color != null ? color : [0.5, 0.5, 0.5];
		
		// -------------- //		
		
		var nH:Float = 2 * Math.tan( lens.yFOV / 2 ) * lens.zNear;
		var nW:Float = nH * lens.viewport.ratio;
		
		var fH:Float = 2 * Math.tan( lens.yFOV / 2 ) * lens.zFar;
		var fW:Float = fH * lens.viewport.ratio;
		
		var ftl:Array<Float> = [ -fW * 0.5,  fH * 0.5, -lens.zFar ];
		var ftr:Array<Float> = [  fW * 0.5,  fH * 0.5, -lens.zFar ];
		var fbl:Array<Float> = [ -fW * 0.5, -fH * 0.5, -lens.zFar ];
		var fbr:Array<Float> = [  fW * 0.5, -fH * 0.5, -lens.zFar ];
		
		var ntl:Array<Float> = [ -nW * 0.5,  nH * 0.5, -lens.zNear ];
		var ntr:Array<Float> = [  nW * 0.5,  nH * 0.5, -lens.zNear ];
		var nbl:Array<Float> = [ -nW * 0.5, -nH * 0.5, -lens.zNear ];
		var nbr:Array<Float> = [  nW * 0.5, -nH * 0.5, -lens.zNear ];
		
		// -------------- //
		
		this.moveTo( ftl, c );
		this.lineTo( ftr, c );
		this.lineTo( fbr, c );
		this.lineTo( fbl, c );
		this.lineTo( ftl, c );
		
		this.moveTo( ntl, c );
		this.lineTo( ntr, c );
		this.lineTo( nbr, c );
		this.lineTo( nbl, c );
		this.lineTo( ntl, c );
		
		this.moveTo( ntl, c );
		this.lineTo( ftl, c );
		
		this.moveTo( ntr, c );
		this.lineTo( ftr, c );
		
		this.moveTo( nbl, c );
		this.lineTo( fbl, c );
		
		this.moveTo( nbr, c );
		this.lineTo( fbr, c );
	}
}