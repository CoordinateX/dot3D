package at.dotpoint.dot3d.scene;

import at.dotpoint.core.entity.IEntity;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.render.RenderUnit;
import at.dotpoint.engine.database.IEntityQuery;
import at.dotpoint.engine.database.IEntityStructure;
import at.dotpoint.engine.database.query.SpatialQuery;
import at.dotpoint.engine.database.QueryType;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.Space;

/**
 * ...
 * @author RK
 */
class Scene implements IEntityStructure<SpatialQuery>
{
	
	/**
	 * type of queries this structure solves
	 */
	public var type:String;
	
	// ---------------- //
	
	public var modelList:Array<Model>;		

	public var camera:Camera;
	public var light:Vector3;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new() 
	{
		this.type = QueryType.SPATIAL;
		this.modelList = new Array<Model>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	public function has( x:IEntity ):Bool
	{
		var model:Model = cast x;
		
		if( model == null )
			return false;
		
		return this.modelList.indexOf( model ) != -1;
	}
	
	/**
	 * 
	 */
	public function add( x:IEntity ):Bool
	{
		var model:Model = cast x;
		
		if( model == null )
			return false;
		
		this.modelList.push( model );
		
		return true;
	}
	
	/**
	 * 
	 */
	public function remove( x:IEntity ):Bool
	{
		var model:Model = cast x;
		
		if( model == null )
			return false;
		
		return this.modelList.remove( model );
	}
	
	/**
	 * 
	 * @return
	 */
	public function iterator():Iterator<IEntity>
	{
		return this.modelList.iterator();
	}
	
	// ---------------------- //
	
	/**
	 * 
	 * @param	query
	 * @return
	 */
	public function search( query:SpatialQuery, ?output:Array<IEntity> ):Array<IEntity>
	{
		return null;
	}
}