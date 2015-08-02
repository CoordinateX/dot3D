package lwjgl.at.dotpoint.dot3d;

import haxe.at.dotpoint.display.DisplayEngine;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.dot3d.scene.Stage3DScene;
import lwjgl.at.dotpoint.dot3d.rendering.Java3DContext;
import lwjgl.at.dotpoint.dot3d.rendering.Java3DRenderer;
import lwjgl.at.dotpoint.dot3d.rendering.renderable.Java3DMeshBuffer;
import lwjgl.at.dotpoint.dot3d.rendering.renderable.Java3DRenderable;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShaderProgram;
import lwjgl.at.dotpoint.dot3d.shader.TestShader;

/**
 * ...
 * @author RK
 */
class Java3DEngine extends DisplayEngine
{

	/**
	 *
	 */
	private var renderer:Java3DRenderer;

	/**
	 *
	 */
	private var context:Java3DContext;

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

		this.renderer = new Java3DRenderer();
		this.context = new Java3DContext();
		this.scene = new Stage3DScene();
	}

	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public override function getRenderer():Java3DRenderer
	{
		return this.renderer;
	}

	/**
	 *
	 * @return
	 */
	public override function getContext():Java3DContext
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
			var shader:Java3DShaderProgram = new TestShader();

			entity.setRenderer( new Java3DRenderable( shader, new Java3DMeshBuffer() ) );
		}
	}

}