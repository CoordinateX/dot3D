package at.dotpoint.dot3d.primitives.geodesic;

import at.dotpoint.math.Trigonometry;
import haxe.ds.Vector;
import at.dotpoint.math.vector.Vector2;
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
	public var ID:String;

	// -------------------- //
	// areas

	/**
	 * penta/hexagon area
	 */
	public var areaCell:Float;

	/**
	 * triangle area between center and neighbor-centers
	 */
	public var areaCorners:Vector<Float>;

	/**
	 * quadrillateral between center and corner (1/3rd of CornerArea)
	 */
	public var areaSegments:Vector<Float>;

	// -------------------- //

	/**
	 * graph
	 */
	public var neighbors:Vector<GeodesicCell>;

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
	// toString
	// ************************************************************************ //

	/**
	 *
	 */
	public function toString():String
	{
		return "[GeodesicCell: " + this.ID + " ]";
	}


}
