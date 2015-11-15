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

	/**
	 *
	 */
	private var settings:OceanParams;

	/**
	 *
	 */
	private var generator:OceanGenerator;

	// --------- //

	private var counter:Float;

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

		Stage3DEngine.instance.getScene().camera.transform.position.z += 90;
		Stage3DEngine.instance.getScene().camera.transform.position.y += 20;

		// ---------- //

		this.counter = 0;

		this.settings 	= new OceanParams();
		this.ocean 		= new OceanGrid( this.settings, 2, 2 );

		this.generator = new OceanGenerator( this.settings, this.ocean );
		this.generator.initialize();

		for( patch in this.ocean.patches )
			this.addDisplayObjectToScene( patch );
	}

	/**
	 *
	 */
	override function onTick():Void
	{
		this.transformControl.speedTranslation = 0.6;
		this.transformControl.update( Stage3DEngine.instance.getScene().camera.transform );

		this.generator.update( this.counter );
		this.counter += 0.025;

		super.onTick();
	}
}