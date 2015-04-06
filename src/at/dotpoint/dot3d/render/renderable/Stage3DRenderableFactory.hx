package at.dotpoint.dot3d.render.renderable;

import at.dotpoint.display.IDisplayObject;
import at.dotpoint.display.rendering.IRenderer;
import at.dotpoint.display.rendering.renderable.IRenderable;
import at.dotpoint.display.rendering.renderable.IRenderableFactory;
import at.dotpoint.dot3d.geometry.shader.DiffuseColorShader;
import at.dotpoint.logger.Log;

/**
 * ...
 * @author RK
 */
class Stage3DRenderableFactory implements IRenderableFactory<IDisplayObject>
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	context
	 * @param	entity
	 * @return
	 */
	public function getRenderable( renderer:IRenderer, entity:IDisplayObject ):IRenderable<IDisplayObject>
	{
		if( !Std.is( renderer, Stage3DRenderer ) )
			throw "unsupported IRenderer: " + renderer;
		
		if( entity.getModel().material == null )
		{
			Log.warn( "no material set, default one is used" );
		}
		
		// ---------- //
		
		return new Stage3DRenderable( new DiffuseColorShader(), new Stage3DMeshBuffer(), cast renderer );
	}
}