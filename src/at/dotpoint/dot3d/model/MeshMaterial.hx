package at.dotpoint.dot3d.model;

import at.dotpoint.dot3d.model.material.Material;

/**
 * 
 */
class MeshMaterial
{
	public var material:Material;
	
	public var start:Int;	// start index in indexbuffer, which the material shall be applied to
	public var length:Int; 	// the number of triangles to render. Each triangle consumes three indices. Pass -1 to draw all triangles in the index buffer. Default -1.
	
	public function new( material:Material, start:Int = 0, length:Int = -1 )
	{
		this.material = material;
		
		this.start = start;
		this.length = length;
	}
}