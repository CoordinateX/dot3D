package at.dotpoint.dot3d;
import at.dotpoint.display.DisplayEngine;
import at.dotpoint.display.IDisplayObject;
import at.dotpoint.display.rendering.IRenderer;
import at.dotpoint.display.Sprite;
import at.dotpoint.dot3d.geometry.shader.DiffuseColorShader;
import at.dotpoint.dot3d.render.renderable.Stage3DMeshBuffer;
import at.dotpoint.dot3d.render.renderable.Stage3DRenderable;
import at.dotpoint.dot3d.render.Stage3DContext;
import at.dotpoint.dot3d.render.Stage3DRenderer;
import at.dotpoint.dot3d.scene.Stage3DScene;

/**
 * ...
 * @author RK
 */
class Stage3DEngine extends DisplayEngine
{

	/**
	 * 
	 */
	public static var instance(default, null):Stage3DEngine = new Stage3DEngine(); 
	
	// ------------------- //
	
	/**
	 * 
	 */
	private var renderer:Stage3DRenderer;
	
	/**
	 * 
	 */
	private var context:Stage3DContext;
	
	/**
	 * 
	 */
	private var scene:Stage3DScene;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new() 
	{
		super();
		
		this.renderer = new Stage3DRenderer();
		this.context = new Stage3DContext();
		this.scene = new Stage3DScene();
	}
	
	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public override function getRenderer():Stage3DRenderer 
	{
		return this.renderer;
	}
	
	/**
	 * 
	 * @return
	 */
	public override function getContext():Stage3DContext 
	{
		return this.context;
	}
	
	/**
	 * 
	 * @return
	 */
	public override function getScene():Stage3DScene 
	{
		return this.scene;
	}
	
	// ************************************************************************ //
	// Method
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	entity
	 */
	override private function setEntityRenderer( entity:IDisplayObject ):Void
	{
		if( Std.is( entity, Sprite ) )
		{
			entity.setRenderer( new Stage3DRenderable( new DiffuseColorShader(), new Stage3DMeshBuffer() ) );
		}
	}
	
}