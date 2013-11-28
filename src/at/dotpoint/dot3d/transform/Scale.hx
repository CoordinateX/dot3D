package at.dotpoint.dot3d.transform;

import at.dotpoint.dot3d.transform.LazyVector3;
import at.dotpoint.math.vector.Matrix44;

/**
 * Manages the Scale using DirtyVector
 * @author Gerald Hattensauer
 */
class Scale extends LazyVector3
{
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( x:Float = 1, y:Float = 1, z:Float = 1 ) 
	{
		super( x, y, z );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * @return this.x == this.y == this.z;
	 */
	public function isUniform():Bool
	{
		return (this.x == this.y && this.x == this.z);
	}
	
	public function isIdentity():Bool
	{
		return this.isUniform() && this.x == 1;
	}
	
	/**
	 * sets the components for scale of the given matrix using its vector;
	 * creates a new one; 
	 */
	public function getMatrix( ?output:Matrix44 ):Matrix44 
	{
		output = output != null ? output : new Matrix44();
		output.m11 = this.x;
		output.m22 = this.y;
		output.m33 = this.z;
		
		return output;
	}
	
	/**
	 * takes the components for scale of the given matrix and calls setComponents;
	 */
	public function setMatrix( matrix:Matrix44 ):Void
	{
		this.setComponents( matrix.m11, matrix.m22, matrix.m33 );
	}
}