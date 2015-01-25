package at.dotpoint.dot3d.primitives;
import at.dotpoint.core.dispatcher.Event;
import at.dotpoint.core.event.event.EvaluateEvent;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.camera.Lens;
import at.dotpoint.dot3d.camera.PerspectiveLens;
import at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class Frustum extends Line
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( camera:Camera ) 
	{
		super( 12, 6 );		
		this.draw( camera );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	

	/**
	 * 
	 * @param	lens
	 */
	private function draw( camera:Camera ):Void
	{		
		if( Std.is( camera.lense, PerspectiveLens ) )
		{
			this.drawPerspective( cast camera.lense );			
		}		
	}
	
	private function drawPerspective( lens:PerspectiveLens ):Void 
	{
		var c:Array<Float> = [0.5, 0.5, 0.5];
		
		// -------------- //
		
		var nH:Float = 2 * Math.tan( lens.yFOV / 2 ) * lens.zNear;
		var nW:Float = nH * lens.screen.ratio;
		
		var fH:Float = 2 * Math.tan( lens.yFOV / 2 ) * lens.zFar;
		var fW:Float = fH * lens.screen.ratio;
		
		var ftl:Vector3 = new Vector3( -fW * 0.5,  fH * 0.5, -lens.zFar );
		var ftr:Vector3 = new Vector3(  fW * 0.5,  fH * 0.5, -lens.zFar );
		var fbl:Vector3 = new Vector3( -fW * 0.5, -fH * 0.5, -lens.zFar );
		var fbr:Vector3 = new Vector3(  fW * 0.5, -fH * 0.5, -lens.zFar );
		
		var ntl:Vector3 = new Vector3( -nW * 0.5,  nH * 0.5, -lens.zNear );
		var ntr:Vector3 = new Vector3(  nW * 0.5,  nH * 0.5, -lens.zNear );
		var nbl:Vector3 = new Vector3( -nW * 0.5, -nH * 0.5, -lens.zNear );
		var nbr:Vector3 = new Vector3(  nW * 0.5, -nH * 0.5, -lens.zNear );
		
		// -------------- //
		
		this.moveTo( ftl.toArray(), c );
		this.lineTo( ftr.toArray(), c );
		this.lineTo( fbr.toArray(), c );
		this.lineTo( fbl.toArray(), c );
		this.lineTo( ftl.toArray(), c );
		
		this.moveTo( ntl.toArray(), c );
		this.lineTo( ntr.toArray(), c );
		this.lineTo( nbr.toArray(), c );
		this.lineTo( nbl.toArray(), c );
		this.lineTo( ntl.toArray(), c );
		
		this.moveTo( ntl.toArray(), c );
		this.lineTo( ftl.toArray(), c );
		
		this.moveTo( ntr.toArray(), c );
		this.lineTo( ftr.toArray(), c );
		
		this.moveTo( nbl.toArray(), c );
		this.lineTo( fbl.toArray(), c );
		
		this.moveTo( nbr.toArray(), c );
		this.lineTo( fbr.toArray(), c );
	}
	
}