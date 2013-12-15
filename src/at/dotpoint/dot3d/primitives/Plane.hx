package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.EditableMesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.Register;

/**
 * ordinary plane, but has to be plugged into a Model as this is just a mesh.
 * has position information.
 * 
 * @author RK
 */
class Plane extends EditableMesh
{

	
	public function new( w:Float, h:Float, backface:Bool = false ) 
	{
		var signature:MeshSignature = new MeshSignature( 4, 2, 1 );		
			signature.addType( Register.VERTEX_POSITION, 4 ); 
			
		super( signature );
		
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
		this.startVertexData( Register.VERTEX_POSITION );
		
		this.addVertexData( [ -w, -h, 0 ] );
		this.addVertexData( [ -w,  h, 0 ] );
		this.addVertexData( [  w,  h, 0 ] );
		this.addVertexData( [  w, -h, 0 ] );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces( backface ):Void
	{
		this.createFace( [0, 1, 2] );
		this.createFace( [2, 3, 0] );
	}
		
}