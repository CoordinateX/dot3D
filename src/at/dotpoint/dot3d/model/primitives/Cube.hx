package at.dotpoint.dot3d.model.primitives;

import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshData;
import at.dotpoint.dot3d.model.register.container.RegisterTable;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * ...
 * @author RK
 */
class Cube extends Mesh
{

	
	public function new( w:Float, h:Float, l:Float ) 
	{
		super( new MeshData( new RegisterTable( 8 ) ) );
		
		w = w * 0.5;
		h = h * 0.5;
		l = l * 0.5;
		
		this.setupFaces();
		this.setupVertices( w, h, l );	
		
		this.setupUVs();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	private function setupFaces():Void
	{
		this.setIndexData( 0, 1, 2 );
		this.setIndexData( 2, 3, 0 );
		
		this.setIndexData( 4, 5, 6 );		
		this.setIndexData( 6, 7, 4 );
		
		this.setIndexData( 0, 3, 5 );
		this.setIndexData( 5, 4, 0 );
		
		this.setIndexData( 3, 2, 6 );
		this.setIndexData( 6, 5, 3 );
		
		this.setIndexData( 2, 1, 7 );		
		this.setIndexData( 7, 6, 2 );
		
		this.setIndexData( 1, 0, 4 );
		this.setIndexData( 4, 7, 1 );
	}
	
	/**
	 * 
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	private function setupVertices( w:Float, h:Float, l:Float ):Void
	{
		this.setVertexData( Register.VERTEX_POSITION, 0, [ -w, -h, -l ] );
		this.setVertexData( Register.VERTEX_POSITION, 1, [ -w,  h, -l ] );
		this.setVertexData( Register.VERTEX_POSITION, 2, [  w,  h, -l ] );
		this.setVertexData( Register.VERTEX_POSITION, 3, [  w, -h, -l ] );
		
		this.setVertexData( Register.VERTEX_POSITION, 4, [ -w, -h,  l ] );
		this.setVertexData( Register.VERTEX_POSITION, 5, [  w, -h,  l ] );
		this.setVertexData( Register.VERTEX_POSITION, 6, [  w,  h,  l ] );
		this.setVertexData( Register.VERTEX_POSITION, 7, [ -w,  h,  l ] );	
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// Normals:
	
	/**
	 * 
	 */
	/*private function setupNormals():Void
	{
		var n1:Array<Float> = [  0.,  0., -1. ];
		var n2:Array<Float> = [  0.,  0.,  1. ];
		var n3:Array<Float> = [  0., -1.,  0. ];
		
		var n4:Array<Float> = [  1.,  0.,  0. ];
		var n5:Array<Float> = [  0.,  1.,  0. ];
		var n6:Array<Float> = [ -1.,  0.,  0. ];
		
		this.setFaceData( Register.VERTEX_NORMAL, 0, [ n1, n2, n3 ] );
		this.setFaceData( Register.VERTEX_NORMAL, 0, [ n1, n2, n3 ] );
	}*/	
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// Normals:
	
	/**
	 * 
	 */
	private function setupUVs():Void
	{
		this.setVertexData( Register.VERTEX_UV, 0, [0., 0.] ); //should set for all
	}
	
}