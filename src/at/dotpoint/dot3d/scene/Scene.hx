package at.dotpoint.dot3d.scene;

import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
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
		
		for( model in this.modelList )
		{			
			var unit:RenderUnit = new RenderUnit();
				unit.context 	= model.material.contextSetting;
				unit.shader 	= model.material.shader;				
				unit.mesh 		= model.mesh;
				
			unit.shaderData = this.createShaderInput( model );
			
			unitList.push( unit );
		}
		
		return unitList;
	}
	
	private function createShaderInput( model:Model ):ShaderInput
	{
		var input:ShaderInput = new ShaderInput();
		
		var vertexInput:Array<RegisterType> = model.material.reflectVertexArguments();
		//var fragmentInput:Array<RegisterType> = model.material.reflectFragmentArguments();
		
		for( vType in vertexInput )
		{
			if( vType.ID == Register.MODEL_WORLD.ID )
			{
				input.set( vType.ID, model.getTransform( Space.WorldSpace ).getMatrix() );
			}
			
			if( vType.ID == Register.WORLD_CAMERA.ID )
			{
				input.set( vType.ID, this.camera.getProjectionMatrix() );
			}
			
			if( vType.ID == Register.LIGHT.ID )
			{
				input.set( vType.ID, this.light );
			}
			
			if( vType.ID == Register.CAMERA_POSITION.ID )
			{
				input.set( vType.ID, this.camera.getTransform( Space.WorldSpace ).position.getVector() );
			}			
		}
		
		return input;
	}
}