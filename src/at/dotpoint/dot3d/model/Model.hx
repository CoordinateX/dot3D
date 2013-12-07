package at.dotpoint.dot3d.model;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.ShaderSpecification;
import at.dotpoint.dot3d.model.mesh.Mesh;

/**
 * Model is a combination of pure geometry (Mesh) and a collection of Materials applied to specific regions of the Mesh
 * The Mesh maybe shared between many different Models. Like Mesh, the Model is unique for each instance in the scene and
 * exists only once. Any Model in your scene is a ModelInstance refering to a Model. 
 * 
 * Models with the same geometry might have different materials. For example a character might be as any other character, 
 * but has a different Material. In this case the Mesh is the same, but the MeshMaterial is different. The MeshMaterial 
 * might be very similar like any other character but might has a different diffuse Texture. 
 * 
 * @author Gerald Hattensauer
 */
class Model
{
	
	/**
	 * geometry: vertex + index buffer
	 */
	public var mesh:Mesh;
	
	/**
	 * material, shader, textures - can also be applied to mesh sub regions only 
	 */
	public var materials:Array<MeshMaterial>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( ?mesh:Mesh ) 
	{
		this.mesh = mesh;
		this.materials = new Array<MeshMaterial>();
	}	
	

}

