package at.dotpoint.dot3d.scene;

import at.dotpoint.core.entity.IEntity;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class Scene
{
	
	public var modelList:Array<Model>;		

	public var camera:Camera;
	public var light:Vector3;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new() 
	{
		this.modelList = new Array<Model>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	public function has( model:Model ):Bool
	{
		if( model == null )
			return false;
		
		return this.modelList.indexOf( model ) != -1;
	}
	
	/**
	 * 
	 */
	public function add( model:Model ):Bool
	{
		if( model == null )
			return false;
		
		this.modelList.push( model );
		
		return true;
	}
	
	/**
	 * 
	 */
	public function remove( model:Model ):Bool
	{
		if( model == null )
			return false;
		
		return this.modelList.remove( model );
	}
	
	/**
	 * 
	 * @return
	 */
	public function iterator():Iterator<Model>
	{
		return this.modelList.iterator();
	}
	
}