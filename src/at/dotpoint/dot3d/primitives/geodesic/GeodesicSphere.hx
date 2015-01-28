package at.dotpoint.dot3d.primitives.geodesic;

import Math;
import at.dotpoint.dot3d.model.mesh.editable.MeshTriangle;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.mesh.editable.MeshVertex;
import at.dotpoint.math.MathUtil;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.primitives.icosahedron.IcosahedronTriangle;
import haxe.ds.Vector;
import at.dotpoint.dot3d.primitives.icosahedron.Icosahedron.IcosahedronMesh;
import at.dotpoint.dot3d.model.Model;

/**
 * ...
 * @author RK
 */
class GeodesicSphere extends Model
{
	public function new( ?settings:GeodesicSettings = null )
	{
		if( settings == null )
			settings = GeodesicSettings.CELLS_12;

		super( new GeodesicSphereMesh( settings ).buildMesh() );
	}
}

/**
 *
 */
class GeodesicSphereMesh extends IcosahedronMesh
{

	/**
	 *
	 */
	private var vertices:Array<MeshVertex>;

	/**
	 *
	 */
	public var cells:Array<GeodesicCell>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( settings:GeodesicSettings )
	{
		super( settings );
		this.generateGeodesic();
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 */
	private function generateGeodesic():Void
	{
		this.vertices   = this.getVertexList();
		this.cells      = this.generateCells();

		this.buildGeodesicGeometry();
	}

	/**
	 * cCells
	 */
	public function generateCells():Array<GeodesicCell>
	{
		var cells:Array<GeodesicCell> = new Array<GeodesicCell>();

		for( vertex in this.vertices )
		{
			var tris:Array<IcosahedronTriangle> = this.gatherCellTriangles( vertex, this.triangles );
			var cell:GeodesicCell 				= this.createCell( vertex, tris );

			cells.push( cell );
		}

		return cells;
	}

	/**
	 *
	 */
	private function buildGeodesicGeometry():Void
	{
		var triangles:Array<MeshTriangle> = new Array<MeshTriangle>();

		for( cell in this.cells )
		{
			var v1:MeshVertex = new MeshVertex( cell.center );
				v1.uv = this.calculateUV( cell.center );

			for( j in 0...cell.vertices.length )
			{
				var p2:Vector3 = cell.vertices[(j + 1) % cell.vertices.length];
				var p3:Vector3 = cell.vertices[(j + 0) % cell.vertices.length];

				// -------------------- //

				var v2:MeshVertex = new MeshVertex( p2 );
					v2.uv = this.calculateUV( p2 );

				var v3:MeshVertex = new MeshVertex( p3 );
					v3.uv = this.calculateUV( p3 );

				var face:MeshTriangle = new MeshTriangle();
					face.v1 = v1;
					face.v2 = v2;
					face.v3 = v3;

				triangles.push( face );

				// -------------------- //

				v1.normal = cell.normal;
				v2.normal = cell.normal;
				v3.normal = cell.normal;
			}
		}

		this.reset();
		this.addTriangleList( triangles );
	}

	// ************************************************************************ //
	// gatherCells
	// ************************************************************************ //

	/**
	 *
	 * @param	vertex
	 */
	private function gatherCellTriangles( vertex:MeshVertex, triangles:Vector<IcosahedronTriangle>, ?result:Array<IcosahedronTriangle> ):Array<IcosahedronTriangle>
	{
		if( result == null )
			result = new Array<IcosahedronTriangle>();

		for( triangle in triangles )
		{
			if( triangle.children == null )
			{
				if( this.isPointInTriangle( vertex, triangle ) )
					result.push( triangle );
			}
			else
			{
				this.gatherCellTriangles( vertex, triangle.children, result );
			}
		}

		return result;
	}

	/**
	 *
	 * @param	point
	 * @param	triangle
	 * @return
	 */
	private function isPointInTriangle( vertex:MeshVertex, triangle:IcosahedronTriangle ):Bool
	{
		var position:Vector3 = vertex.position;

		for( j in 0...3 )
		{
			if( Vector3.isEqual( position, triangle.getVertex( j ).position ) )
				return true;
		}

		return false;
	}

	// ************************************************************************ //
	// createCells
	// ************************************************************************ //

	/**
	 *
	 */
	private function createCell( vertex:MeshVertex, triangles:Array<IcosahedronTriangle> ):GeodesicCell
	{
		var cell:GeodesicCell = new GeodesicCell();
			cell.vertices   = this.getCorners( vertex, triangles );
			cell.center     = this.calculateCellCenter( cell.vertices );
			cell.normal     = vertex.normal;

		return cell;
	}

	/**
	 * center of each triangle is a corner of the cell
	 *
	 * @param	center
	 * @param	triangles
	 * @return
	 */
	private function getCorners( vertex:MeshVertex, triangles:Array<IcosahedronTriangle> ):Array<Vector3>
	{
		var corners:Array<Vector3> = new Array<Vector3>();

		for( triangle in triangles )
		{
			var v1:Vector3 = triangle.v1.position;
			var v2:Vector3 = triangle.v2.position;
			var v3:Vector3 = triangle.v3.position;

			var sum:Vector3 = new Vector3();
				sum.x = (v1.x + v2.x + v3.x ) / 3;
				sum.y = (v1.y + v2.y + v3.y ) / 3;
				sum.z = (v1.z + v2.z + v3.z ) / 3;

			corners.push( sum );
		}

		return this.sortCorners( vertex, corners );
	}

	/**
	 *
	 * @param	vIndex
	 * @param	corners
	 * @return
	 */
	private function sortCorners( vertex:MeshVertex, corners:Array<Vector3> ):Array<Vector3>
	{
		var cPosition:Vector3 = vertex.position;
		var cNormal:Vector3   = vertex.normal;

		var guide:Vector3  = Vector3.subtract( cPosition, corners[0] );

		// ----------------------- //
		// angle:

		function sortAngle( v1:Vector3, v2:Vector3 ):Int
		{
			var line1:Vector3 	= Vector3.subtract( cPosition, v1 );
			var line2:Vector3 	= Vector3.subtract( cPosition, v2 );

			var angle1:Float = Vector3.getAngle( guide, line1, cNormal ) * MathUtil.RAD_DEG;
			var angle2:Float = Vector3.getAngle( guide, line2, cNormal ) * MathUtil.RAD_DEG;

			return Math.round(angle2 - angle1);
		}

		corners.sort( sortAngle );

		// ----------------------- //

		return corners;
	}

	/**
	 *
	 */
	private function calculateCellCenter( corners:Array<Vector3> ):Vector3
	{
		var total:Vector3 = new Vector3();
		var scale:Float = 1 / corners.length;

		for( vertex in corners )
		{
			total = Vector3.add( vertex, total, total );
		}

		total = Vector3.scale( total, scale, total );

		return total;
	}

}