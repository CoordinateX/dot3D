package at.dotpoint.dot3d.render;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.dot3d.shader.TestShader.TShader;
import at.dotpoint.math.geom.Space;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class RenderSystem
{

	/**
	 * 
	 */
	public var renderer:RenderProcessor;
	
	/**
	 * 
	 */
	public var scene:Scene;
	
	/**
	 * 
	 */
	private var cache:Array<RenderUnit>;
	
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
		if( this.cache == null )
		{
			var unitList:Array<RenderUnit> = new Array<RenderUnit>();		
			
			for( model in this.scene.modelList )
			{			
				var unit:RenderUnit = new RenderUnit();				
					unit.model 			= model;	
					unit.shaderInput 	= model.material.createShaderInput();	
				
				unitList.push( unit );
			}
			
			unitList.sort( this.sortRenderUnits );
			
			this.cache = unitList;
		}
		
		for( unit in this.cache )
		{
			this.updateShaderInput( unit );
		}
		
		return this.cache;
	}
	
	/**
	 * 
	 * @param	a
	 * @param	b
	 * @return
	 */
	private function sortRenderUnits( a:RenderUnit, b:RenderUnit ):Int
	{
		if( a.mesh == b.mesh ) 
			return 1;		
		
		//if( a.model.material == b.model.material )	
			//return 1;			
			
		return -1;
	}
	
	/**
	 * 
	 * @param	model
	 * @return
	 */
	private function updateShaderInput( unit:RenderUnit ):Void
	{		
		var input:Vector<RegisterInput> = unit.shaderInput.values;
		
		for( v in 0...input.length )
		{
			var reg:RegisterInput = input[v];
			
			if( reg.type == Register.MODEL_WORLD.ID )
			{
				reg.input = unit.model.getTransform( Space.WORLD ).getMatrix();
				continue;
			}
			
			if( reg.type == Register.WORLD_CAMERA.ID )
			{
				reg.input = this.scene.camera.getProjectionMatrix();
				continue;
			}
			
			if( reg.type == Register.LIGHT.ID )
			{
				reg.input = this.scene.light;
				continue;
			}
			
			if( reg.type == Register.CAMERA_POSITION.ID )
			{
				reg.input = this.scene.camera.getTransform( Space.WORLD ).position/*.clone()*/;
				continue;
			}			
		}
	}
	
}