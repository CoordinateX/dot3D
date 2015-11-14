package gerstner;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.calculations.MeshCalculationTools;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.SharedVertexPolicy;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class WaveGeneratorGerstner
{

	/**
	 *
	 */
	public var amplitude:Float;

	/**
	 *
	 */
	public var sharpness:Float;

	/**
	 *
	 */
	public var frequency:Float;

	/**
	 *
	 */
	public var wavelength:Float;

	/**
	 *
	 */
	public var direction:Vector3;

	// ----------- //

	public var segmentsX:Int;
	public var segmentsY:Int;

	public var w:Float;
	public var h:Float;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.amplitude 	= 2.0  * 0.02;
		this.sharpness 	= 1.8  * 0.02;
		this.frequency 	= 0.6  * 0.02;
		this.wavelength = 15.0 * 0.02;

		this.direction 	= new Vector3( 0.3, 0.0, 0.3 );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	plane
	 * @param	time
	 */
	public function update( plane:IMeshData, time:Float ):Void
	{
		var vertex:Vector3 = new Vector3();

		var xfactor:Float = w / segmentsX;
		var yfactor:Float = h / segmentsY;

		var xscale:Int = segmentsX + 1;
		var yscale:Int = segmentsY + 1;

		//----------------- //

		for( xs in 0...xscale )
		{
			for( ys in 0...yscale )
			{
				var index:Int = ys + xs * yscale;

				var x:Float = -w * 0.5 + xs * xfactor;
				var z:Float = -h * 0.5 + ys * yfactor;

				// -------------------- //

				var data:Array<Float> = plane.getRegisterData( index, RegisterHelper.V_POSITION );

				vertex.x = data[0];
				vertex.y = data[1];
				vertex.z = data[2];

				var scalar:Float = Vector3.dot( this.direction, vertex );

				var k:Float 	= 2 * Math.PI / this.wavelength;
				var magic:Float = k * scalar - this.frequency * time;

				var cos:Float = Math.cos( magic );
				var sin:Float = Math.sin( magic );

				// ------------------ //

				data[0] = x + this.sharpness * this.amplitude * this.direction.x * cos;
				data[2] = z + this.sharpness * this.amplitude * this.direction.z * cos;
				data[1] = this.amplitude * sin;

				plane.setRegisterIndex( data, RegisterHelper.V_POSITION, index );
			}
		}

		//----------------- //

		MeshCalculationTools.recalculateNormals( plane, SharedVertexPolicy.COMBINE );
	}

}