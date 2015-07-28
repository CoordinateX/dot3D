package java.at.dotpoint.dot3d;

import haxe.at.dotpoint.display.DisplayEngine;

/**
 * ...
 * @author RK
 */
class Java3DEngine extends DisplayEngine
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