package at.dotpoint.dot3d.transform;

import at.dotpoint.dot3d.transform.LazyVector3;
import at.dotpoint.math.vector.Matrix44;

/**
 * Manages the Position using DirtyVector
 * @author Gerald Hattensauer
 */
class Position extends LazyVector3 
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( x:Float = 0, y:Float = 0, z:Float = 0 ) 
	{
		super( x, y, z );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * sets the components for translation of the given matrix using its vector;
	 * creates a new one if null or none is given; column-matrix (m14-m34)
	 */
	public function getMatrix( ?output:Matrix44 ):Matrix44
	{
		output = output != null ? output : new Matrix44();
		output.m14 = this.x;
		output.m24 = this.y;
		output.m34 = this.z;
		
		return output;
	}
	
	/**
	 * takes the components for translation of the given matrix and calls setComponents;
	 * column-matrix (m14-m34)
	 */
	public function setMatrix( matrix:Matrix44 ):Void
	{
		this.setComponents( matrix.m14, matrix.m24, matrix.m34 );
	}
}