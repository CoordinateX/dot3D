package at.dotpoint.dot3d.model.primitives;

import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshData;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterData;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * ...
 * @author RK
 */
@:access(at.dotpoint.dot3d.model.mesh)
 //
class Cube extends Mesh
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
		this.data.vertices.addRegisterData( new RegisterData( Register.VERTEX_POSITION, 8 ) );
		
		this.setVertexData( Register.VERTEX_POSITION, 0, [ -w, -h, -l ] );
		this.setVertexData( Register.VERTEX_POSITION, 1, [ -w,  h, -l ] );
		this.setVertexData( Register.VERTEX_POSITION, 2, [  w,  h, -l ] );
		this.setVertexData( Register.VERTEX_POSITION, 3, [  w, -h, -l ] );
		
		this.setVertexData( Register.VERTEX_POSITION, 4, [ -w, -h,  l ] );
		this.setVertexData( Register.VERTEX_POSITION, 5, [  w, -h,  l ] );
		this.setVertexData( Register.VERTEX_POSITION, 6, [  w,  h,  l ] );
		this.setVertexData( Register.VERTEX_POSITION, 7, [ -w,  h,  l ] );	
		
		// ------------------ //
		// UV:
		
		this.data.vertices.addRegisterData( new RegisterData( Register.VERTEX_UV, 4 ) );
		
		this.setVertexData( Register.VERTEX_UV, 0, [ 1., 0. ] );
		this.setVertexData( Register.VERTEX_UV, 1, [ 1., 1. ] );
		this.setVertexData( Register.VERTEX_UV, 1, [ 0., 1. ] );
		this.setVertexData( Register.VERTEX_UV, 1, [ 0., 0. ] );
		
		// ------------------ //
		// Normal:
		
		this.data.vertices.addRegisterData( new RegisterData( Register.VERTEX_NORMAL, 6 ) );
		
		this.setVertexData( Register.VERTEX_NORMAL, 0, [  0.,  0., -1. ] );
		this.setVertexData( Register.VERTEX_NORMAL, 1, [  0.,  0.,  1. ] );
		this.setVertexData( Register.VERTEX_NORMAL, 2, [  0., -1.,  0. ] );
		
		this.setVertexData( Register.VERTEX_NORMAL, 3, [  1.,  0.,  0. ] );
		this.setVertexData( Register.VERTEX_NORMAL, 4, [  0.,  1.,  0. ] );
		this.setVertexData( Register.VERTEX_NORMAL, 5, [ -1.,  0.,  0. ] );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces():Void
	{
		this.setFaceIndices( 0, [0,0,0, 1,1,0, 2,2,0] );
		this.setFaceIndices( 1, [2,2,0, 3,3,0, 0,0,0] );
		
		this.setFaceIndices( 2, [4,3,1, 5,0,1, 6,1,1] );
		this.setFaceIndices( 3, [6,1,1, 7,2,1, 4,3,1] );
		
		this.setFaceIndices( 4, [0,3,2, 3,0,2, 5,1,2] );
		this.setFaceIndices( 5, [5,1,2, 4,2,2, 0,3,2] );
		
		this.setFaceIndices( 6, [3,3,3, 2,0,3, 6,1,3] );
		this.setFaceIndices( 7, [6,1,3, 5,2,3, 3,3,3] );
		
		this.setFaceIndices( 8, [2,3,4, 1,0,4, 7,1,4] );
		this.setFaceIndices( 9, [7,1,4, 6,2,4, 2,3,4] );
		
		this.setFaceIndices(10, [1,3,5, 0,0,5, 4,1,5] );
		this.setFaceIndices(11, [4,1,5, 7,2,5, 1,3,5] );	
	}
	

	

	
}