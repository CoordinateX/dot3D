package at.dotpoint.dot3d.primitives.geodesic;

import at.dotpoint.math.MathUtil;
import at.dotpoint.core.datastructure.VectorUtil;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicCell;
import haxe.ds.Vector;
import at.dotpoint.math.Trigonometry;
import at.dotpoint.core.datastructure.VectorSet;
import at.dotpoint.math.vector.Vector3;
import haxe.ds.StringMap;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicSphere.GeodesicSphereMesh;


class GeodesicGrid
{

	/**
	 *
	 */
	private var centerTable:StringMap<GeodesicCell>;

	/**
	 *
	 */
	private var cornerTable:StringMap<Array<GeodesicCell>>;

	/**
	 *
	 */
	private var cellList:Array<GeodesicCell>;


	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( mesh:GeodesicSphereMesh )
	{
		this.centerTable = new StringMap<GeodesicCell>();
		this.cornerTable = new StringMap<Array<GeodesicCell>>();

		this.generate( mesh );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	private function generate( mesh:GeodesicSphereMesh ):Void
	{
		this.cellList = mesh.cells;

		this.createLookup();
		this.createNeighborGraph();
	}

	// ************************************************************************ //
	// Lookup
	// ************************************************************************ //

	/**
	 *
	 */
	private function createLookup():Void
	{
		for( cell in this.cellList )
		{
			this.centerTable.set( this.getLookupSignature( cell.center ), cell );

			for( corner in cell.corners )
			{
				var signature:String = this.getLookupSignature( corner );

				if( !this.cornerTable.exists( signature ) )
					this.cornerTable.set( signature, new Array<GeodesicCell>() );

				this.cornerTable.get( signature ).push( cell );
			}
		}
	}

	/**
	 *
	 */
	inline private function getLookupSignature( data:Vector3 ):String
	{
		return data.x + "_" + data.y + "_" + data.z + "_" + data.w;
	}

	// -------------------- //

	/**
	 *
	 */
	public function getCenterCell( center:Vector3 ):GeodesicCell
	{
		return this.centerTable.get( this.getLookupSignature(center) );
	}

	/**
	 *
	 */
	public function getCornerCells( corner:Vector3 ):Array<GeodesicCell>
	{
		return this.cornerTable.get( this.getLookupSignature(corner) );
	}

	// ************************************************************************ //
	// Graph
	// ************************************************************************ //

	/**
	 *
	 */
	private function createNeighborGraph():Void
	{
		for( cell in this.cellList )
		{
			var set:VectorSet<GeodesicCell> = new VectorSet<GeodesicCell>( cell.corners.length, false );

			for( j in 0...cell.corners.length )
			{
				var potential:Array<GeodesicCell> = this.getCornerCells( cell.corners[j] );

				for( neighbor in potential )
				{
					if( neighbor != cell )
						set.add( neighbor );
				}
			}

			cell.neighbors = this.getSortedNeighbors( cell, set );
		}
	}

	/**
	 *
	 */
	private function getSortedNeighbors( cell:GeodesicCell, set:VectorSet<GeodesicCell> ):Vector<GeodesicCell>
	{
		var list:Vector<GeodesicCell> = new Vector<GeodesicCell>( set.size() );

		for( j in 0...set.size() )
			list[j] = set.get( j );

		var guide:Vector3  = Vector3.subtract( cell.center, cell.corners[0] );

		// ----------------------- //
		// angle:

		function sortAngle( v1:GeodesicCell, v2:GeodesicCell ):Int
		{
			var line1:Vector3 	= Vector3.subtract( cell.center, v1.center );
			var line2:Vector3 	= Vector3.subtract( cell.center, v2.center );

			var angle1:Float = Trigonometry.getRadianAngle( guide, line1, cell.normal ) * MathUtil.RAD_DEG;
			var angle2:Float = Trigonometry.getRadianAngle( guide, line2, cell.normal ) * MathUtil.RAD_DEG;

			return Math.round(angle2 - angle1);
		}

		VectorUtil.sort( list, sortAngle );

		// ----------------------- //

		return list;
	}

	// ************************************************************************ //
	// precalculate
	// ************************************************************************ //

	/**
	 *
	 */
	public function precalculate():Void
	{
		for( cell in this.cellList )
		{
			this.calculateAreas( cell );
		}
	}

	// ************************************************************************ //
	// Area
	// ************************************************************************ //

	/**
	 *
	 */
	private function calculateAreas( cell:GeodesicCell ):Void
	{
		if( cell.corners == null || cell.corners.length < 3 )
			throw "cell undefined, cannot calculate Areas";

		if( cell.neighbors == null || cell.neighbors.length < 3 )
			throw "cell graph undefined, cannot calculate Areas";

		// -------------- //

		this.calculateCellArea( cell );
		this.calculateCornerArea( cell );
		this.calculateSegmentArea( cell );
	}

	/**
	 * penta/hexagon area
	 */
	private function calculateCellArea( cell:GeodesicCell ):Void
	{
		var aC:Vector3 = cell.corners[0];
		var bC:Vector3 = cell.corners[1];

		cell.areaCell = 0;

		// ------------ //

		for( j in 2...cell.corners.length )
		{
			cell.areaCell += Trigonometry.calculatetArea( aC, bC, cell.corners[j] );
		}
	}

	/**
	 * triangle area between center and neighbor-centers
	 */
	private function calculateCornerArea( cell:GeodesicCell ):Void
	{
		cell.areaCorners  = new Vector<Float>( cell.corners.length );

		// ------------ //

		for( j in 0...cell.corners.length )
		{
			var potential:Array<GeodesicCell> = this.getCornerCells( cell.corners[j] );

			var a:GeodesicCell = potential[0] != cell ? potential[0] : potential[1];
			var b:GeodesicCell = potential[2] != cell ? potential[2] : potential[1];

			cell.areaCorners[j] = Trigonometry.calculatetArea( cell.center, a.center, b.center );
		}
	}

	/**
	 * quadrillateral between center and corner (1/3rd of CornerArea)
	 */
	private function calculateSegmentArea( cell:GeodesicCell ):Void
	{
		cell.areaSegments = new Vector<Float>( cell.corners.length );

		// ------------ //

		for( j in 0...cell.corners.length )
		{
			var aI:Int = ((j - 1) % cell.corners.length + cell.corners.length) % cell.corners.length;
			var bI:Int = ((j + 1) % cell.corners.length + cell.corners.length) % cell.corners.length;

			var a:Vector3 = Vector3.scale( cell.corners[aI], 0.5 );
			var b:Vector3 = Vector3.scale( cell.corners[bI], 0.5 );
			var c:Vector3 = cell.corners[j];

			cell.areaSegments[j]  = Trigonometry.calculatetArea( cell.center, a, c );
			cell.areaSegments[j] += Trigonometry.calculatetArea( cell.center, b, c );
		}
	}

}
