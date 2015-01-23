package at.dotpoint.dot3d.render;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.dot3d.shader.TestShader.TShader;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.Matrix44;
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
	 */
	public function reset():Void
	{
		this.renderer.reset();
		
		for( unit in this.cache )
		{
			unit.shader.getInstance().program = null;
		}
		
		this.scene.modelList = new Array<Model>();
		this.cache = null;
	}
	
	/**
	 * 
	 * @return
	 */
	private function generateRenderUnits():Array<RenderUnit> 
	{
		if( this.cache == null || true )
		{
			var unitList:Array<RenderUnit> = new Array<RenderUnit>();		
			
			for( model in this.scene.modelList )
			{			
				var unit:RenderUnit = new RenderUnit( model );				
					unit.shaderInput 	= model.material.createShaderInput();	
				
				unitList.push( unit );
			}
			
			unitList.sort( this.sortRenderUnits );
			
			this.cache = unitList;
		}
		
		this.mproj = this.scene.camera.getProjectionMatrix();
		
		for( unit in this.cache )
		{
			this.updateShaderInput( unit );
			//unit.material.applyInput( unit.shaderInput );
		}
		
		return this.cache;
	}
	
	private var mproj:Matrix44;
	
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
		
		for( reg in input )
		{
			switch( reg.type )
			{
				case "mpos":
					reg.input = unit.model.transformations.worldSpace.getMatrix();
					
				case "mproj":
					reg.input = this.mproj; //this.scene.camera.getProjectionMatrix();
					
				case "light":
					reg.input = this.scene.light;
					
				case "cam":
					reg.input = this.scene.camera.getTransform( Space.WORLD ).position;
			}			
		}
	}
	
}