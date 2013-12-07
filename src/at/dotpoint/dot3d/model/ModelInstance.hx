package at.dotpoint.dot3d.model;

import at.dotpoint.tilezeit.entity.EntityContainer;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.tilezeit.IUniqueID;
import at.dotpoint.tilezeit.Space;

/**
 * actual model within the scene, has its local/world transformation and a reference to the model it uses for rendering
 * animations, bounds, physic, collision etc all happens with this one
 * 
 * @author Gerald Hattensauer
 */
class ModelInstance extends EntityContainer implements IUniqueID
{

	public var ID(default, null):String;
	public var reference(default,null):Model;
	
	// public var bounds:Boundings;
	// public var animation:Animation;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( ID:String, model:Model ) 
	{
		super();
		
		this.ID = ID;
		this.reference = model;
	}
	
}