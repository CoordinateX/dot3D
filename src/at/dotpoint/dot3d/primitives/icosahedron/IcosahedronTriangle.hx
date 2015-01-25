package at.dotpoint.dot3d.primitives.icosahedron;

import at.dotpoint.math.vector.Vector3;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class IcosahedronTriangle
{

	/**
	 * indices pointing to the vertex positions, clockwise order ...
	 */
	public var vIndices(default, null):Vector<Int>;	
	
	/**
	 * normal of the triangle, not the same as its vertices
	 */
	public var normal:Vector3;
	
	// ------------- //
	
	/**
	 * index of the face
	 */
	public var ID:String;
	
	/**
	 * triangle higher up the hierachy
	 */
	public var parent:IcosahedronTriangle;
	
	/**
	 * 4 triangles lower down the hierachy
	 */
	public var children:Vector<IcosahedronTriangle>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		this.vIndices = new Vector<Int>( 3 );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	

}