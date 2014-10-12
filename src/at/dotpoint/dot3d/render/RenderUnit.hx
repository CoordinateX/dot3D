package at.dotpoint.dot3d.render;

import at.dotpoint.dot3d.model.material.ContextSettings;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshBuffer;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.math.vector.Matrix44;
import hxsl.Shader;

/**
 * ...
 * @author RK
 */
class RenderUnit
{

	/**
	 * 
	 */
	public var model:Model;
	
	/**
	 * 
	 */
	public var shaderInput:ShaderInput;
	
	// ----------- //
	
	/**
	 * 
	 */
	public var mesh(get, null):Mesh;	
	
	/**
	 * 
	 */
	public var material(get,null):Material<Shader>;	
	
	// ----------- //
	
	/**
	 * 
	 */
	public var shader(get, null):Shader;
	
	/**
	 * 
	 */
	public var context(get,null):ContextSettings;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?model:Model ) 
	{
		this.model = model;
	}
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function get_mesh():Mesh { return this.model.mesh; }
	
	private function get_material():Material<Shader> { return this.model.material; }
	
	private function get_shader():Shader { return this.material.shader; }
	
	private function get_context():ContextSettings { return this.material.contextSetting; }
}