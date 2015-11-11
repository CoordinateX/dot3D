package flash.at.dotpoint.dot3d;

import flash.at.dotpoint.dot3d.rendering.Flash3DContext;
import flash.at.dotpoint.dot3d.rendering.Flash3DRenderer;
import flash.at.dotpoint.dot3d.rendering.renderable.Flash3DMeshBuffer;
import flash.at.dotpoint.dot3d.rendering.renderable.Flash3DRenderable;
import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShader;
import flash.at.dotpoint.dot3d.shader.DiffuseShader;
import flash.at.dotpoint.dot3d.shader.MeshColorShader;
import haxe.at.dotpoint.display.DisplayEngine;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.dot3d.rendering.Stage3DContext;
import haxe.at.dotpoint.dot3d.rendering.Stage3DRenderer;
import haxe.at.dotpoint.dot3d.scene.Stage3DScene;
import flash.at.dotpoint.dot3d.shader.LineShader;

/**
 * ...
 * @author RK
 */
class Flash3DEngine extends DisplayEngine
{
	
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
		
		this.renderer = new Flash3DRenderer();
		this.context = new Flash3DContext();
		this.scene = new Stage3DScene();
	}
	
	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public override function getRenderer():Flash3DRenderer 
	{
		return this.renderer;
	}
	
	/**
	 * 
	 * @return
	 */
	public override function getContext():Flash3DContext 
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
			var shader:Flash3DShader = new DiffuseShader();
			
			if( entity.getComponent( ModelRenderData ).signature.ID == "MeshColor" )
				shader = new MeshColorShader();	
			
			if( entity.getComponent( ModelRenderData ).signature.ID == "line" )
				shader = new LineShader();		
				
			entity.setRenderer( new Flash3DRenderable( shader, new Flash3DMeshBuffer() ) );
		}
	}
	
}