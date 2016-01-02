package haxe.at.dotpoint.dot3d.renderable.mesh;

import haxe.at.dotpoint.display.renderable.mesh.AMesh;
import haxe.at.dotpoint.display.renderable.mesh.data.complex.ComplexMeshData;
import haxe.at.dotpoint.display.renderable.mesh.data.MeshData;
import haxe.at.dotpoint.display.renderable.register.RegisterHelper;



/**
 * ...
 * @author RK
 */
class CubeMesh extends AMesh
{

	//
	public static var NAME(default, null):String = "cube";

	//
	public function new( ?w:Float = 1, ?h:Float = 1, ?l:Float = 1 )
	{
		super( new CubeMeshData( CubeMesh.NAME, w, h, l ) );
	}

}

/**
 * ...
 * @author RK
 */
class CubeMeshData extends MeshData
{

	/**
	 *
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	public function new( name:String, w:Float, h:Float, l:Float )
	{
		super( name );

		w = w * 0.5;
		h = h * 0.5;
		l = l * 0.5;

		this.setupVertices( w, h, l );
		this.setupFaces();
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	private function setupVertices( w:Float, h:Float, l:Float ):Void
	{
		this.addRegisterData( [ -w, -h, -l ], RegisterHelper.V_POSITION  );
		this.addRegisterData( [ -w,  h, -l ], RegisterHelper.V_POSITION  );
		this.addRegisterData( [  w,  h, -l ], RegisterHelper.V_POSITION  );
		this.addRegisterData( [  w, -h, -l ], RegisterHelper.V_POSITION  );

		this.addRegisterData( [ -w, -h,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterData( [  w, -h,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterData( [  w,  h,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterData( [ -w,  h,  l ], RegisterHelper.V_POSITION  );

		// ------------------ //
		// UV:

		this.addRegisterData( [ 1., 0. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterData( [ 1., 1. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterData( [ 0., 1. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterData( [ 0., 0. ], RegisterHelper.V_UV_COORDINATES );

		// ------------------ //
		// Normal:

		this.addRegisterData( [  0.,  0., -1. ], RegisterHelper.V_NORMAL );
		this.addRegisterData( [  0.,  0.,  1. ], RegisterHelper.V_NORMAL );
		this.addRegisterData( [  0., -1.,  0. ], RegisterHelper.V_NORMAL );

		this.addRegisterData( [  1.,  0.,  0. ], RegisterHelper.V_NORMAL );
		this.addRegisterData( [  0.,  1.,  0. ], RegisterHelper.V_NORMAL );
		this.addRegisterData( [ -1.,  0.,  0. ], RegisterHelper.V_NORMAL );
	}

	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:

	/**
	 *
	 */
	private function setupFaces():Void
	{
		var complex:ComplexMeshData = new ComplexMeshData( this );

		complex.addTriangleByVertexIndices( [0,0,0, 1,1,0, 2,2,0] );
		complex.addTriangleByVertexIndices( [2,2,0, 3,3,0, 0,0,0] );

		complex.addTriangleByVertexIndices( [4,3,1, 5,0,1, 6,1,1] );
		complex.addTriangleByVertexIndices( [6,1,1, 7,2,1, 4,3,1] );

		complex.addTriangleByVertexIndices( [0,3,2, 3,0,2, 5,1,2] );
		complex.addTriangleByVertexIndices( [5,1,2, 4,2,2, 0,3,2] );

		complex.addTriangleByVertexIndices( [3,3,3, 2,0,3, 6,1,3] );
		complex.addTriangleByVertexIndices( [6,1,3, 5,2,3, 3,3,3] );

		complex.addTriangleByVertexIndices( [2,3,4, 1,0,4, 7,1,4] );
		complex.addTriangleByVertexIndices( [7,1,4, 6,2,4, 2,3,4] );

		complex.addTriangleByVertexIndices( [1,3,5, 0,0,5, 4,1,5] );
		complex.addTriangleByVertexIndices( [4,1,5, 7,2,5, 1,3,5] );
	}
}