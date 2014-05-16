package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.EditableMesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;

/**
 * 
 */
class Cube extends Model
{
	public function new( w:Float, h:Float, l:Float ) 
	{
		super( new CubeMesh( w, h, l ) );
	}
}

/**
 * ordinary cube, but has to be plugged into a Model as this is just a mesh.
 * has position, uv and normal information.
 * 
 * @author RK
 */
class CubeMesh extends EditableMesh
{

	
	public function new( w:Float, h:Float, l:Float ) 
	{
		var signature:MeshSignature = new MeshSignature( 24, 12, 3 );		
			signature.addType( Register.VERTEX_POSITION, 8 ); 
			signature.addType( Register.VERTEX_UV, 		 4 ); 
			signature.addType( Register.VERTEX_NORMAL,   6 ); 
			
		super( signature );
		
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
		this.startVertexData( Register.VERTEX_POSITION );
		
		this.addVertexData( [ -w, -h, -l ] );
		this.addVertexData( [ -w,  h, -l ] );
		this.addVertexData( [  w,  h, -l ] );
		this.addVertexData( [  w, -h, -l ] );
		
		this.addVertexData( [ -w, -h,  l ] );
		this.addVertexData( [  w, -h,  l ] );
		this.addVertexData( [  w,  h,  l ] );
		this.addVertexData( [ -w,  h,  l ] );	
		
		// ------------------ //
		// UV:
		
		this.startVertexData( Register.VERTEX_UV );
		
		this.addVertexData( [ 1., 0. ] );
		this.addVertexData( [ 1., 1. ] );
		this.addVertexData( [ 0., 1. ] );
		this.addVertexData( [ 0., 0. ] );
		
		// ------------------ //
		// Normal:
		
		this.startVertexData( Register.VERTEX_NORMAL );
		
		this.addVertexData( [  0.,  0., -1. ] );
		this.addVertexData( [  0.,  0.,  1. ] );
		this.addVertexData( [  0., -1.,  0. ] );
		
		this.addVertexData( [  1.,  0.,  0. ] );
		this.addVertexData( [  0.,  1.,  0. ] );
		this.addVertexData( [ -1.,  0.,  0. ] );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces():Void
	{
		this.createFace( [0,0,0, 1,1,0, 2,2,0] );
		this.createFace( [2,2,0, 3,3,0, 0,0,0] );
		
		this.createFace( [4,3,1, 5,0,1, 6,1,1] );
		this.createFace( [6,1,1, 7,2,1, 4,3,1] );
		
		this.createFace( [0,3,2, 3,0,2, 5,1,2] );
		this.createFace( [5,1,2, 4,2,2, 0,3,2] );
		
		this.createFace( [3,3,3, 2,0,3, 6,1,3] );
		this.createFace( [6,1,3, 5,2,3, 3,3,3] );
		
		this.createFace( [2,3,4, 1,0,4, 7,1,4] );
		this.createFace( [7,1,4, 6,2,4, 2,3,4] );
		
		this.createFace( [1,3,5, 0,0,5, 4,1,5] );
		this.createFace( [4,1,5, 7,2,5, 1,3,5] );	
	}
		
}