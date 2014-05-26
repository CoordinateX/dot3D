package at.dotpoint.dot3d.render;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.engine.Engine;
import at.dotpoint.engine.IEngineSystem;

/**
 * ...
 * @author RK
 */
class RenderSystem implements IEngineSystem
{

	/**
	 * instance to pass messages to and listen as well
	 */
	public var engine:Engine;
	
	// ----------- //
	
	/**
	 * 
	 */
	public var renderer:RenderProcessor;
	
	/**
	 * 
	 */
	public var scene:Scene;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( renderer:RenderProcessor, scene:Scene ) 
	{
		this.renderer = renderer;
		this.scene = scene;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
		/**
	 * 
	 * @param	interpolation
	 */
	public function update( interpolation:Float ):Bool
	{
		this.renderer.render( this.generateRenderUnits() );
		
		return true;
	}
	
	/**
	 * 
	 * @return
	 */
	private function generateRenderUnits():Array<RenderUnit> 
	{
		var unitList:Array<RenderUnit> = new Array<RenderUnit>();		
		
		for( model in this.scene.modelList )
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
	
	/**
	 * 
	 * @param	model
	 * @return
	 */
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
				continue;
			}
			
			if( vType.ID == Register.WORLD_CAMERA.ID )
			{
				input.set( vType.ID, this.scene.camera.getProjectionMatrix() );
				continue;
			}
			
			if( vType.ID == Register.LIGHT.ID )
			{
				input.set( vType.ID, this.scene.light );
				continue;
			}
			
			if( vType.ID == Register.CAMERA_POSITION.ID )
			{
				input.set( vType.ID, this.scene.camera.getTransform( Space.WorldSpace ).position.getVector() );
				continue;
			}			
		}
		
		return input;
	}
	
}