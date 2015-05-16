package haxe.at.dotpoint.dot3d.scene;

import haxe.at.dotpoint.core.datastructure.graph.TreeNode;
import haxe.at.dotpoint.display.IDisplayObject;
import haxe.at.dotpoint.display.register.RegisterHelper;
import haxe.at.dotpoint.display.register.RegisterType;
import haxe.at.dotpoint.display.scene.IScene;
import haxe.at.dotpoint.dot3d.camera.Stage3DCamera;

/**
 * ...
 * @author RK
 */
class Stage3DScene implements IScene<IDisplayObject>
{

	/**
	 * 
	 */
	public var camera:Stage3DCamera;
	
	/**
	 * 
	 */
	private var spatialTree:TreeNode<IDisplayObject>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		this.spatialTree = new TreeNode<IDisplayObject>( true );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public function getSpatialTree():TreeNode<IDisplayObject> 
	{
		return this.spatialTree;
	}
	
	/**
	 * 
	 * @param	entity
	 * @param	type
	 * @return
	 */
	public function getRegisterData<T:Dynamic>( entity:IDisplayObject, type:RegisterType ):T 
	{
		if( type.ID ==  RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
			return cast this.camera.getCamera().getProjectionMatrix();		
		
		return null;
	}
}