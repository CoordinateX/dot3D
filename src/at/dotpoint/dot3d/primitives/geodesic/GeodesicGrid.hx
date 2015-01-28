package at.dotpoint.dot3d.primitives.geodesic;

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
			cell.neighbors = new VectorSet( cell.corners.length, false );

			for( corner in cell.corners )
			{
				var potential:Array<GeodesicCell> = this.getCornerCells( corner );

				for( neighbor in potential )
				{
					if( neighbor != cell )
						cell.neighbors.add( neighbor );
				}
			}
		}
	}

}
