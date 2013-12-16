package at.dotpoint.dot3d.scene;

import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.render.RenderUnit;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.Space;

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
	 * @return
	 */
	public function gatherRenderUnits():Array<RenderUnit> 
	{
		var unitList:Array<RenderUnit> = new Array<RenderUnit>();		
		
		var w2c:Matrix44 	= this.camera.getProjectionMatrix();		
		var camPos:Vector3 	= this.camera.getTransform( Space.WorldSpace ).position.getVector();
		var light:Vector3 	= this.light;
		
		
		for( model in this.modelList )
		{			
			var m2w:Matrix44 = model.getTransform( Space.WorldSpace ).getMatrix();
			
			Reflect.setProperty( model.material.shader, Register.MODEL_WORLD.ID, m2w );
			Reflect.setProperty( model.material.shader, Register.WORLD_CAMERA.ID, w2c );
			
			// --------------- //
			// camera:
			
			if( Reflect.hasField( model.material.shader, "cam" ) )
				Reflect.setProperty( model.material.shader, "cam", camPos );
			
			// --------------- //
			// light:
			
			//if( Reflect.hasField( model.material.shader, "light" ) )
				Reflect.setProperty( model.material.shader, "light", this.light );	
			
			//	trace( Reflect.fields( model.material )  );	
			
			//trace( model.material.shader.getDebugShaderCode() );
			
			// --------------- //	
				
			var unit:RenderUnit = new RenderUnit();
				unit.context 	= model.material.contextSetting;
				unit.shader 	= model.material.shader;
				unit.mesh 		= model.mesh;
				
			unitList.push( unit );
		}
		
		return unitList;
	}
}