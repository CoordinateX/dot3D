package;
import haxe.at.dotpoint.dot3d.primitives.Cube;
import haxe.at.dotpoint.dot3d.primitives.Plane;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.Timer;

/**
 * ...
 * @author RK
 */
class MainGerstner extends Simple3DMain
{

	/**
	 *
	 */
	private static var instance:MainGerstner;

	// --------------- //

	/**
	 *
	 */
	private var ocean:Plane;

	/**
	 *
	 */
	private var waves:WaveGeneratorGerstner;

	/**
	 *
	 */
	private var counter:Float;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		MainGerstner.instance = new MainGerstner();
	}

	public function new()
	{
		if( MainGerstner.instance == null )
			MainGerstner.instance= this;

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

		this.counter = 0;

		var w:Float = 4;
		var h:Float = 4;
		var sx:Int = 20;
		var sy:Int = 20;

		this.waves = new WaveGeneratorGerstner();
		this.waves.segmentsX = sx;
		this.waves.segmentsY = sy;
		this.waves.w = w;
		this.waves.h = h;

		this.ocean = new Plane( w, h, sx, sy );

		this.addDisplayObjectToScene( this.ocean );
	}

	/**
	 *
	 */
	override function onTick():Void
	{
		this.transformControl.update( Stage3DEngine.instance.getScene().camera.transform );
		this.waves.update( this.ocean.mesh, this.counter++ );

		super.onTick();
	}
}