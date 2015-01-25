package at.dotpoint.dot3d.primitives.icosahedron;

class IcosahedronSettings
{
	/**
	 * presets ...
	 */
	public static var CELLS_12:IcosahedronSettings 		= new IcosahedronSettings(    12, 0 );
	public static var CELLS_42:IcosahedronSettings 		= new IcosahedronSettings(    42, 1 );
	public static var CELLS_162:IcosahedronSettings 	= new IcosahedronSettings(   162, 2 );
	public static var CELLS_642:IcosahedronSettings 	= new IcosahedronSettings(   642, 3 );
	public static var CELLS_2562:IcosahedronSettings 	= new IcosahedronSettings(  2562, 4 );
	public static var CELLS_10242:IcosahedronSettings 	= new IcosahedronSettings( 10242, 5 );

	// --------------------------- //
	// --------------------------- //

	/**
	 * cells
	 */
	public var total(default,null):Int;

	/**
	 *
	 */
	public var tesselationDepth(default, null):Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
	 *
	 * @param	total
	 * @param 	tesselation
	 */
	private function new( total:Int, tesselation:Int )
	{
		this.total = total;
		this.tesselationDepth = tesselation;
	}

}
