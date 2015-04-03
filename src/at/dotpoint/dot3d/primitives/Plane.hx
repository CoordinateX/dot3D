package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.editable.CustomMesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;

/**
 * 
 */
class Plane extends Model
{
	public function new( w:Float, h:Float, backface:Bool = false ) 
	{
		super( new PlaneMesh( w, h, backface ).buildMesh() );
	}
}

/**
 * ordinary plane, but has to be plugged into a Model as this is just a mesh.
 * has position information.
 * 
 * @author RK
 */
class PlaneMesh extends CustomMesh
{

	
	public function new( w:Float, h:Float, backface:Bool = false ) 
	{
		super();
		
		w = w * 0.5;
		h = h * 0.5;
		
		this.setupVertices( w, h );	
		this.setupFaces( backface );
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
	private function setupVertices( w:Float, h:Float ):Void
	{
		this.addRegisterData( [ -w, -h, 0 ], Register.VERTEX_POSITION );
		this.addRegisterData( [ -w,  h, 0 ], Register.VERTEX_POSITION );
		this.addRegisterData( [  w,  h, 0 ], Register.VERTEX_POSITION );
		this.addRegisterData( [  w, -h, 0 ], Register.VERTEX_POSITION );

		this.addRegisterData( [ 0, 0, 1 ], Register.VERTEX_NORMAL );

		this.addRegisterData( [ 0, 0 ], Register.VERTEX_UV );
		this.addRegisterData( [ 0, 1 ], Register.VERTEX_UV );
		this.addRegisterData( [ 1, 1 ], Register.VERTEX_UV );
		this.addRegisterData( [ 1, 0 ], Register.VERTEX_UV );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces( backface:Bool ):Void
	{
		this.addFaceIndices( [0,0,0, 1,1,0, 2,2,0] );
		this.addFaceIndices( [2,2,0, 3,3,0, 0,0,0] );
	}		
}