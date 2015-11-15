package fourier;
import haxe.ds.Vector;

/**
 * more or less the speed of water on a given point based on depth/shallowness, gravity and frequency
 */
class OceanDispertion
{

	/**
	 * ocean settings
	 */
	public var settings:OceanParams;

	/**
	 * lookup
	 */
	public var dispertion:Vector<Vector<Float>>;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( settings:OceanParams )
	{
		this.settings = settings;
	}

	public function init():Void
	{
		this.dispertion = new Vector<Vector<Float>>( this.settings.N + 1 );

		for( j in 0...this.settings.N + 1 )
			this.dispertion[j] = new Vector<Float>( this.settings.N + 1 );

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
		var w0:Float = 2.0 * Math.PI / this.settings.frequency;

		// --------- //

		for( n in 0...this.settings.N + 1 )
		{
			for( m in 0...this.settings.N + 1 )
			{
				this.dispertion[n][m] = Math.ffloor( this.calculate( n, m ) / w0 ) * w0;
			}
		}
	}

	/**
	 *
	 * @param	n
	 * @param	m
	 * @return
	 */
	private function calculate( n:Int, m:Int ):Float
	{
		var kx:Float = this.settings.getKComponent( n );
		var ky:Float = this.settings.getKComponent( m );
		var k1:Float = Math.sqrt( kx * kx + ky * ky );

		var depth:Float = this.getDepth( n, m, k1 );

		return Math.sqrt( this.settings.GRAVITY * k1 * depth );
	}

	/**
	 *
	 * @param	n
	 * @param	m
	 * @param	k1
	 * @return
	 */
	private function getDepth( n:Int, m:Int, k1:Float ):Float
	{
		var X:Float = this.settings.getDepth( n, m ) * k1;

		var EX1:Float = Math.exp( X);
		var EX2:Float = Math.exp(-X);

		return (EX1 - EX2) / (EX1 + EX2);
	}
}