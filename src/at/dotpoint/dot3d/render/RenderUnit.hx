package at.dotpoint.dot3d.render;

import at.dotpoint.dot3d.model.material.ContextSettings;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshBuffer;
import at.dotpoint.math.vector.Matrix44;
import hxsl.Shader;

/**
 * ...
 * @author RK
 */
class RenderUnit
{

	public var mesh:Mesh;
	
	public var shader:Shader;
	public var context:ContextSettings;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		
	}
	
}