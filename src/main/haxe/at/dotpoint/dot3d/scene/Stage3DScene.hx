package haxe.at.dotpoint.dot3d.scene;

import haxe.at.dotpoint.core.datastructure.graph.TreeNode;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.scene.IScene;
import haxe.at.dotpoint.dot3d.camera.Stage3DCamera;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Vector3;

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
		
		if( type.ID ==  RegisterHelper.W_CAMERA_POSITION.ID )
		{
			var pos:IVector3 = this.camera.transform.position;
			
			return cast new Vector3( pos.x, pos.y, pos.z, pos.w );	
		}
			
		return null;
	}
}