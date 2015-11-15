package fourier;
import haxe.at.dotpoint.math.vector.IVector2;
import haxe.at.dotpoint.math.vector.Vector2;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class OceanSpectrum
{

	/**
	 * ocean settings
	 */
	public var settings:OceanParams;

	/**
	 * lookup
	 */
	public var spectrum_norm:Vector<Vector<IVector2>>;

	/**
	 * lookup
	 */
	public var spectrum_conj:Vector<Vector<IVector2>>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( settings:OceanParams )
	{
		this.settings = settings;
	}

	public function init():Void
	{
		this.spectrum_norm = new Vector<Vector<IVector2>>( this.settings.N + 1 );
		this.spectrum_conj = new Vector<Vector<IVector2>>( this.settings.N + 1 );

		for( j in 0...this.settings.N + 1 )
		{
			this.spectrum_norm[j] = new Vector<IVector2>( this.settings.N + 1 );
			this.spectrum_conj[j] = new Vector<IVector2>( this.settings.N + 1 );
		}

		this.update();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function update():Void
	{
		var k_norm:IVector2;
		var k_conj:IVector2;

		for( n in 0...(this.settings.N + 1) )
		{
			for( m in 0...(this.settings.N + 1) )
			{
				k_norm = this.settings.getKVector(  n,  m, new Vector2() ); // h0
				k_conj = this.settings.getKVector( -n, -m, new Vector2() ); // conjungat of complex h0

				this.spectrum_norm[n][m] = this.h0( n, m, k_norm, new Vector2() );
				this.spectrum_conj[n][m] = this.h0( n, m, k_conj, new Vector2() );
				this.spectrum_conj[n][m].y *= -1.0;
			}
		}
	}

	/**
	 * ( 1 / sqrt(2) ) * ( random() + i * random() ) * sqrt( philips( k ) )
	 */
	private function h0( n:Int, m:Int, k:IVector2, output:IVector2 ):IVector2
	{
		var scale:Float = Math.sqrt( this.phillips( n, m, k ) / 2.0 );	// philips( k ) * sqrt(1/2);

		var c_h0:IVector2 = this.gaussianRandom( output );				// random() + i * random();
			c_h0.x *= scale;
			c_h0.y *= scale;

		return c_h0;
	}

	/**
	 * ( A * exp( -1 / ( k.length * max )^2 ) / k.length^4 ) * (|dot(k,w)|)^2 [* dampening ...]
	 */
	private function phillips( n:Int, m:Int, k:IVector2 ):Float
	{
		var k_length0:Float = k.length();

		if( k_length0 < 0.000001 )
			return 0.0;

		// ---------------- //

		var w:IVector2 = this.settings.getWindVector( n, m );

		var k_unit:Vector2 = Vector2.clone( k );
			k_unit.normalize();

		var w_unit:Vector2 = Vector2.clone( w );
			w_unit.normalize();

		// ---------------- //

		var w_length0:Float = w.length();
		var w_length2:Float = w_length0 * w_length0;

		var k_length2:Float = k_length0 * k_length0;
		var k_length4:Float = k_length2 * k_length2;

		var kw_dot0:Float = k_unit.x * w_unit.x + k_unit.y * w_unit.y;
		var kw_dot2:Float = kw_dot0 * kw_dot0;
		var kw_dot4:Float = kw_dot2 * kw_dot2;

		var L0:Float = w_length2 / this.settings.GRAVITY;
		var L2:Float = L0 * L0;

		var l2:Float = L2 * 0.001 * 0.001;

		// ---------------- //

		var damping:Float  = Math.exp( -k_length2 * l2 );
		var phillips:Float = Math.exp( -1.0 / (k_length2 * L2) ) / k_length4;

		return this.settings.amplitude * phillips * kw_dot4 * damping;
	}

	/**
	 * gaussian random value between -1 and 1; standard diviation 1
	 */
	private function gaussianRandom( r:IVector2 ):IVector2
	{
		var w:Float = 0.0;

		do
		{
			r.x = 2.0 * Math.random() - 1.0;
			r.y = 2.0 * Math.random() - 1.0;

			w = r.x * r.x + r.y * r.y;
		}
		while( w >= 1.0 );

		w = Math.sqrt( ( -2.0 * Math.log(w) ) / w );

		r.x *= w;
		r.y *= w;

		return r;
	}
}