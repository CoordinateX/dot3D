package fourier;

import fourier.OceanGrid;
import haxe.at.dotpoint.dot3d.Stage3DEngine;

/**
 * ...
 * @author RK
 */
class MainFourier extends Simple3DMain
{

	/**
	 *
	 */
	private static var instance:MainFourier;

	// --------------- //

	/**
	 *
	 */
	private var ocean:OceanGrid;
	private var settings:OceanParams;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		MainFourier.instance = new MainFourier();
	}

	public function new()
	{
		if( MainFourier.instance == null )
			MainFourier.instance= this;

		super();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override function initScene():Void
	{
		super.initScene();

		// ---------- //

		this.settings = new OceanParams();
		this.ocean = new OceanGrid( this.settings, 1, 1 );

		for( patch in this.ocean.patches )
			this.addDisplayObjectToScene( patch );
	}

	/**
	 *
	 */
	override function onTick():Void
	{
		this.transformControl.update( Stage3DEngine.instance.getScene().camera.transform );
		super.onTick();
	}
}