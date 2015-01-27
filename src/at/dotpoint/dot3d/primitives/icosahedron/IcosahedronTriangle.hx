package at.dotpoint.dot3d.primitives.icosahedron;

import at.dotpoint.dot3d.model.mesh.editable.MeshTriangle;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class IcosahedronTriangle extends MeshTriangle
{

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
		super();
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function toString():String
	{
		return "[Triangle:" + this.ID + "]";
	}

}