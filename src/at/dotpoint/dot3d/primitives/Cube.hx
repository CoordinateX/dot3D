package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.editable.CustomMesh;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;

/**
 * primitive cube
 **/
class Cube extends Model
{
	public function new( w:Float, h:Float, l:Float ) 
	{
		super( new CubeMesh( w, h, l ).buildMesh() );
	}
}

/**
 * ordinary cube, but has to be plugged into a Model as this is just a mesh.
 * has position, uv and normal information.
 * 
 * @author RK
 */
class CubeMesh extends CustomMesh
{

	
	public function new( w:Float, h:Float, l:Float ) 
	{
		super();
		
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
		this.addRegisterData( [ -w, -h, -l ], Register.VERTEX_POSITION  );
		this.addRegisterData( [ -w,  h, -l ], Register.VERTEX_POSITION  );
		this.addRegisterData( [  w,  h, -l ], Register.VERTEX_POSITION  );
		this.addRegisterData( [  w, -h, -l ], Register.VERTEX_POSITION  );
		
		this.addRegisterData( [ -w, -h,  l ], Register.VERTEX_POSITION  );
		this.addRegisterData( [  w, -h,  l ], Register.VERTEX_POSITION  );
		this.addRegisterData( [  w,  h,  l ], Register.VERTEX_POSITION  );
		this.addRegisterData( [ -w,  h,  l ], Register.VERTEX_POSITION  );
		
		// ------------------ //
		// UV:

		this.addRegisterData( [ 1., 0. ], Register.VERTEX_UV  );
		this.addRegisterData( [ 1., 1. ], Register.VERTEX_UV  );
		this.addRegisterData( [ 0., 1. ], Register.VERTEX_UV  );
		this.addRegisterData( [ 0., 0. ], Register.VERTEX_UV  );
		
		// ------------------ //
		// Normal:

		this.addRegisterData( [  0.,  0., -1. ], Register.VERTEX_NORMAL );
		this.addRegisterData( [  0.,  0.,  1. ], Register.VERTEX_NORMAL );
		this.addRegisterData( [  0., -1.,  0. ], Register.VERTEX_NORMAL );
		
		this.addRegisterData( [  1.,  0.,  0. ], Register.VERTEX_NORMAL );
		this.addRegisterData( [  0.,  1.,  0. ], Register.VERTEX_NORMAL );
		this.addRegisterData( [ -1.,  0.,  0. ], Register.VERTEX_NORMAL );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces():Void
	{
		this.addFaceIndices( [0,0,0, 1,1,0, 2,2,0] );
		this.addFaceIndices( [2,2,0, 3,3,0, 0,0,0] );
		
		this.addFaceIndices( [4,3,1, 5,0,1, 6,1,1] );
		this.addFaceIndices( [6,1,1, 7,2,1, 4,3,1] );
		
		this.addFaceIndices( [0,3,2, 3,0,2, 5,1,2] );
		this.addFaceIndices( [5,1,2, 4,2,2, 0,3,2] );
		
		this.addFaceIndices( [3,3,3, 2,0,3, 6,1,3] );
		this.addFaceIndices( [6,1,3, 5,2,3, 3,3,3] );
		
		this.addFaceIndices( [2,3,4, 1,0,4, 7,1,4] );
		this.addFaceIndices( [7,1,4, 6,2,4, 2,3,4] );
		
		this.addFaceIndices( [1,3,5, 0,0,5, 4,1,5] );
		this.addFaceIndices( [4,1,5, 7,2,5, 1,3,5] );
	}
		
}