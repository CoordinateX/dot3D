package at.dotpoint.dot3d.primitives.geodesic;

import at.dotpoint.dot3d.primitives.icosahedron.IcosahedronSettings;

/**
 * ...
 * @author RK
 */
class GeodesicSettings extends IcosahedronSettings
{
/**
	 * presets ...
	 */
	public static var CELLS_12:GeodesicSettings 	= new GeodesicSettings(    12, 0 );
	public static var CELLS_42:GeodesicSettings 	= new GeodesicSettings(    42, 1 );
	public static var CELLS_162:GeodesicSettings 	= new GeodesicSettings(   162, 2 );
	public static var CELLS_642:GeodesicSettings 	= new GeodesicSettings(   642, 3 );
	public static var CELLS_2562:GeodesicSettings 	= new GeodesicSettings(  2562, 4 );
	public static var CELLS_10242:GeodesicSettings 	= new GeodesicSettings( 10242, 5 );

	// --------------------------- //
	// --------------------------- //

	private function new( total:Int, tesselation:Int )
	{
		super( total, tesselation );
	}
}
