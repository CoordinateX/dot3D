package at.dotpoint.dot3d.primitives.icosahedron;

import at.dotpoint.dot3d.model.Model;
import haxe.ds.Vector;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.mesh.EditableMesh;

class Icosahedron extends Model
{
	public function new( ?settings:IcosahedronSettings = null )
	{
		if( settings == null )
			settings = IcosahedronSettings.CELLS_12;

		super( new IcosahedronMesh( settings ) );
	}
}

/**
 *
 */
class IcosahedronMesh extends EditableMesh
{

	/**
	 * min required for gedesic sphere
	 */
	private static var MIN_TRIANGLES (default,null):Int  = 20;
	private static var MIN_VERTICES  (default, null):Int = 12;

	// ------------------ //

	/**
	 *
	 */
	public var triangles(default,null):Vector<IcosahedronTriangle>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( settings:IcosahedronSettings )
	{
		var numVertices:Int = settings.total;
		var numFaces:Int 	= MIN_TRIANGLES * Math.round( Math.pow(4, settings.tesselationDepth ) );

		var signature:MeshSignature = new MeshSignature( numVertices, numFaces, 2 );
			signature.addType( Register.VERTEX_POSITION, numVertices );
			signature.addType( Register.VERTEX_UV, 		 1 			 );
			signature.addType( Register.VERTEX_NORMAL,   numVertices );

		super( signature );

		// ---------------------- //

		this.triangles = new Vector<IcosahedronTriangle>( MIN_TRIANGLES );

		this.create( settings );
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	private function create( settings:IcosahedronSettings ):Void
	{
		this.addVertexData( [0.0,0.0], Register.VERTEX_UV );

		// -------------- //

		var vList:Vector<Vector3> = this.getInitialVertices();
		var iList:Vector<Vector3> = this.getInitialIndices();

		for( j in 0...IcosahedronMesh.MIN_TRIANGLES )
		{
			var v1:Vector3 = vList[ Std.int( iList[j].x ) ];
			var v2:Vector3 = vList[ Std.int( iList[j].y ) ];
			var v3:Vector3 = vList[ Std.int( iList[j].z ) ];

			this.triangles[j] = this.subdivide( v1, v2, v3, null, settings.tesselationDepth, j );
		}
	}

/**
	 *
	 * @param	v1
	 * @param	v2
	 * @param	v3
	 */
	private function subdivide( v1:Vector3, v2:Vector3, v3:Vector3, parent:IcosahedronTriangle, depth:Int, count:Int ):IcosahedronTriangle
	{
		if( depth == 0 )
		{
			var vIndex0:Int = this.addPosition( v1 );
			var vIndex1:Int = this.addPosition( v2 );
			var vIndex2:Int = this.addPosition( v3 );

			var child:IcosahedronTriangle = this.generateTriangle( parent, count );
				child.vIndices[0] = vIndex0;
				child.vIndices[1] = vIndex1;
				child.vIndices[2] = vIndex2;
				child.normal 	  = this.addNormal( vIndex0, vIndex1, vIndex2 );

			this.createFace( [vIndex0, 0, vIndex0, vIndex1, 0, vIndex1, vIndex2, 0, vIndex2] );

			return child;
		}
		else
		{
			depth--;

			// ------------ //

			var v12:Vector3 = Vector3.add( v1, v2 );
				v12.normalize();

			var v23:Vector3 = Vector3.add( v2, v3 );
				v23.normalize();

			var v31:Vector3 = Vector3.add( v3, v1 );
				v31.normalize();

			// ------------ //

			var triangle:IcosahedronTriangle = this.generateTriangle( parent, count );
				triangle.vIndices[0] = this.addPosition( v1 );
				triangle.vIndices[1] = this.addPosition( v2 );
				triangle.vIndices[2] = this.addPosition( v3 );
				triangle.normal 	 = this.calculatetNormal( triangle.vIndices[0], triangle.vIndices[1], triangle.vIndices[2] );

			var t1:IcosahedronTriangle = this.subdivide(  v1, v12, v31, triangle, depth, 0 );
			var t2:IcosahedronTriangle = this.subdivide(  v2, v23, v12, triangle, depth, 1 );
			var t3:IcosahedronTriangle = this.subdivide(  v3, v31, v23, triangle, depth, 2 );
			var t4:IcosahedronTriangle = this.subdivide( v12, v23, v31, triangle, depth, 3 );

			triangle.children = new Vector<IcosahedronTriangle>( 4 );
			triangle.children[0] = t1;
			triangle.children[1] = t2;
			triangle.children[2] = t3;
			triangle.children[3] = t4;

			return triangle;
		}
	}

	/**
	 *
	 * @param	parent
	 * @param	count
	 * @return
	 */
	private function generateTriangle( parent:IcosahedronTriangle, count:Int ):IcosahedronTriangle
	{
		var triangle:IcosahedronTriangle = new IcosahedronTriangle();
			triangle.ID = parent == null ? "T." + count : parent.ID + "." + count;
			triangle.parent = parent;

		return triangle;
	}

	// ************************************************************************ //
	// Initial Values
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	private function getInitialVertices():Vector<Vector3>
	{
		var X:Float = 0.525731112119133606;
		var Z:Float = 0.850650808352039932;

		var vList:Vector<Vector3> = new Vector<Vector3>( IcosahedronMesh.MIN_VERTICES );

		vList[0 ] = new Vector3(  -X, 0.0,   Z );
		vList[1 ] = new Vector3(   X, 0.0,   Z );
		vList[2 ] = new Vector3(  -X, 0.0,  -Z );
		vList[3 ] = new Vector3(   X, 0.0,  -Z );

		vList[4 ] = new Vector3( 0.0,   Z,   X );
		vList[5 ] = new Vector3( 0.0,   Z,  -X );
		vList[6 ] = new Vector3( 0.0,  -Z,   X );
		vList[7 ] = new Vector3( 0.0,  -Z,  -X );

		vList[8 ] = new Vector3(   Z,   X, 0.0 );
		vList[9 ] = new Vector3(  -Z,   X, 0.0 );
		vList[10] = new Vector3(   Z,  -X, 0.0 );
		vList[11] = new Vector3(  -Z,  -X, 0.0 );

		return vList;
	}

	/**
	 *
	 * @return
	 */
	private function getInitialIndices():Vector<Vector3>
	{
		var iList:Vector<Vector3> = new Vector<Vector3>( IcosahedronMesh.MIN_TRIANGLES );

		iList[0 ] = new Vector3(  0,  4,  1 );
		iList[1 ] = new Vector3(  0,  9,  4 );
		iList[2 ] = new Vector3(  9,  5,  4 );
		iList[3 ] = new Vector3(  4,  5,  8 );
		iList[4 ] = new Vector3(  4,  8,  1 );

		iList[5 ] = new Vector3(  8, 10,  1 );
		iList[6 ] = new Vector3(  8,  3, 10 );
		iList[7 ] = new Vector3(  5,  3,  8 );
		iList[8 ] = new Vector3(  5,  2,  3 );
		iList[9 ] = new Vector3(  2,  7,  3 );

		iList[10] = new Vector3(  7, 10,  3 );
		iList[11] = new Vector3(  7,  6, 10 );
		iList[12] = new Vector3(  7, 11,  6 );
		iList[13] = new Vector3( 11,  0,  6 );
		iList[14] = new Vector3(  0,  1,  6 );

		iList[15] = new Vector3(  6,  1, 10 );
		iList[16] = new Vector3(  9,  0, 11 );
		iList[17] = new Vector3(  9, 11,  2 );
		iList[18] = new Vector3(  9,  2,  5 );
		iList[19] = new Vector3(  7,  2, 11 );

		return iList;
	}

}
