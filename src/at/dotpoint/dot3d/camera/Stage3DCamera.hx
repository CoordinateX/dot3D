package at.dotpoint.dot3d.camera;
import at.dotpoint.display.camera.CameraComponent;
import at.dotpoint.display.camera.ICameraComponent;
import at.dotpoint.display.camera.ICameraEntity;
import at.dotpoint.display.camera.ICameraLens;
import at.dotpoint.display.rendering.context.RenderViewport;
import at.dotpoint.spatial.SpatialEntity;

/**
 * ...
 * @author RK
 */
class Stage3DCamera extends SpatialEntity implements ICameraEntity<SpatialEntity>
{

	/**
	 * 
	 */
	private var camera:ICameraComponent<SpatialEntity>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( lens:ICameraLens ) 
	{
		super( 4 );
		
		this.camera = new CameraComponent<SpatialEntity>( lens );
		this.addComponent( this.camera );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //
	
	/**
	 * 
	 * @return
	 */
	public function getCamera():ICameraComponent<SpatialEntity>
	{
		return this.camera;
	}
}