package;

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

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{

	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	plane
	 * @param	time
	 */
	private function update( plane:IMeshData, time:Float ):Void
	{
		var amplitude:Float 	= 2.0;
		var sharpness:Float 	= 1.8;
		var frequency:Float 	= 0.6;
		var wavelength:Float 	= 15.0;

		var direction:Vector3 = new Vector3( 0.3, 0.0, -0.3 );

		//----------------- //

		var vertex:Vector3 = new Vector3();
		var length:Int = plane.getMeshSignature().numVertices;

		for( j in 0...length )
		{
			var data:Array<Float> = plane.getRegisterData( j, RegisterHelper.V_POSITION );

			vertex.x = data[0];
			vertex.y = data[1];
			vertex.z = data[2];

			var scalar:Float = Vector3.dot( direction, vertex );

			var k:Float 	= 2 * Math.PI / wavelength;
			var magic:Float = k * scalar - frequency * time;

			var cos:Float = Math.cos( magic );
			var sin:Float = Math.sin( magic );

			// ------------------ //

			data[0] = vertex.x + sharpness * amplitude * direction.x * cos;
			data[2] = vertex.z + sharpness * amplitude * direction.z * cos;
			data[1]  = amplitude * sin;

			plane.setRegisterIndex( data, RegisterHelper.V_POSITION, j );
		}

		//----------------- //

		MeshCalculationTools.recalculateNormals( plane, SharedVertexPolicy.COMBINE );
	}

}