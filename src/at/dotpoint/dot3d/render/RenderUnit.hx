package at.dotpoint.dot3d.render;

import at.dotpoint.dot3d.model.material.ContextSettings;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
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
	public var mesh(default, null):Mesh;	
	
	/**
	 * 
	 */
	public var material(default,null):Material<Shader>;	
	
	// ----------- //
	
	/**
	 * 
	 */
	public var shader(default, null):Shader;
	
	/**
	 * 
	 */
	public var context(default,null):ContextSettings;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?model:Model ) 
	{
		this.model = model;
		
		this.mesh 		= this.model.mesh;
		this.material 	= this.model.material;
		this.shader 	= this.material.shader;
		this.context 	= this.material.contextSetting;
	}

}