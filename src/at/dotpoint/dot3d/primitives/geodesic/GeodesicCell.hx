package at.dotpoint.dot3d.primitives.geodesic;

import at.dotpoint.core.datastructure.VectorSet;
import at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class GeodesicCell
{

	/**
	 *
	 */
	public var neighbors:VectorSet<GeodesicCell>;

	// -------------------- //

	/**
	 * sorted clockwise, random starting vertex
	 */
	public var corners:Array<Vector3>;

	/**
	 *
	 */
	public var center:Vector3;

	/**
	 *
	 */
	public var normal:Vector3;

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
	 */
	public function toString():String
	{
		return "[GeodesicCell: " + this.center + " ]";
	}

}
