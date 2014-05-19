package at.dotpoint.dot3d.render;
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
		this.renderer.render( this.scene.gatherRenderUnits() );
		
		return true;
	}
	
}