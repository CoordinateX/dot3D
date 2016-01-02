package haxe.at.dotpoint.dot3d.camera;

import haxe.at.dotpoint.display.camera.CameraComponent;
import haxe.at.dotpoint.display.camera.ICameraComponent;
import haxe.at.dotpoint.display.camera.ICameraEntity;
import haxe.at.dotpoint.display.camera.ICameraFrustum;
import haxe.at.dotpoint.display.camera.ICameraLens;
import haxe.at.dotpoint.math.vector.IMatrix44;
import haxe.at.dotpoint.spatial.SpatialEntity;

/**
 * ...
 * @author RK
 */
class Camera extends SpatialEntity implements ICameraEntity<SpatialEntity>
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

	/**
	 *
	 * @return
	 */
	public function getProjectionMatrix():IMatrix44
	{
		return this.camera.getProjectionMatrix();
	}

	/**
	 *
	 * @return
	 */
	public function getCameraFrustum():ICameraFrustum
	{
		return this.camera.getCameraFrustum();
	}

	/**
	 *
	 * @return
	 */
	public function getCameraLens():ICameraLens
	{
		return this.camera.getCameraLens();
	}
}