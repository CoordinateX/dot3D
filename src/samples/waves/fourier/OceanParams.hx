package fourier;
import haxe.at.dotpoint.math.vector.IVector2;
import haxe.at.dotpoint.math.vector.Vector2;

/**
 * ...
 * @author RK
 */
class OceanParams
{

	//
	public var GRAVITY:Float = 9.81;

	// ---------------- //
	// ---------------- //

	public var isDimensionDirty:Bool;

	@:isVar public var N(get,set):Int;
	@:isVar public var L(get,set):Int;

	@:isVar public var N05(default,null):Float;
	@:isVar public var L01(default,null):Float;

	// ---------------- //
	// dispertion:

	public var isDispertionDirty:Bool;

	@:isVar public var frequency(get,set):Float;

	// ---------------- //
	// spectrum:

	public var isSpectrumDirty:Bool;

	@:isVar public var wind(get,set):Vector2;
	@:isVar public var amplitude(get,set):Float;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		#if flash
		this.N = 32;
		this.L = 32;

		this.frequency = 400;
		this.amplitude = 0.002;
		#else
		this.N = 64;
		this.L = 64;

		this.frequency = 800;
		this.amplitude = 0.0002;
		#end



		this.wind = new Vector2( 32.3, 0.0 );

		// ---------- //

		this.isDimensionDirty = true;
		this.isDispertionDirty = true;
		this.isSpectrumDirty = true;
	}

	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	private function get_N():Int { return this.N; }

	private function set_N( value:Int ):Int
	{
		this.isDimensionDirty = true;

		this.N 	 = value;
		this.N05 = value * 0.5;

		return value;
	}

	/**
	 *
	 * @return
	 */
	private function get_L():Int { return this.L; }

	private function set_L( value:Int ):Int
	{
		this.isDispertionDirty 	= true;
		this.isSpectrumDirty	= true;

		this.L 	 = value;
		this.L01 = 1.0 / value;

		return value;
	}

	/**
	 *
	 * @return
	 */
	private function get_frequency():Float { return this.frequency; }

	private function set_frequency( value:Float ):Float
	{
		this.frequency = value;
		this.isDispertionDirty = true;

		return value;
	}

	/**
	 *
	 * @return
	 */
	private function get_wind():Vector2 { return this.wind; }

	private function set_wind( value:Vector2 ):Vector2
	{
		this.wind = value;
		this.isSpectrumDirty = true;

		return value;
	}

	/**
	 *
	 * @return
	 */
	private function get_amplitude():Float { return this.amplitude; }

	private function set_amplitude( value:Float ):Float
	{
		this.amplitude = value;
		this.isSpectrumDirty = true;

		return value;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	n
	 * @param	m
	 * @param	k
	 * @return
	 */
	public function getKVector( n:Int, m:Int, k:IVector2 ):IVector2
	{
		k.x = this.getKComponent( n );
		k.y = this.getKComponent( m );

		return k;
	}

	/**
	 *
	 * @param	n
	 * @return
	 */
	public function getKComponent( n:Int ):Float
	{
		return 6.28318530718 * (n - this.N05) * this.L01;
	}

	/**
	 *
	 * @param	n
	 * @param	m
	 * @return
	 */
	public function getWindVector( n:Int, m:Int ):IVector2
	{
		return this.wind;
	}

	/**
	 *
	 * @param	n
	 * @param	m
	 * @return
	 */
	public function getDepth( n:Int, m:Int ):Float
	{
		return 2.0;
	}
}