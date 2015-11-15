package fourier;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.math.signal.FastFourierTransform;
import haxe.at.dotpoint.math.vector.IVector2;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Vector2;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class OceanGenerator
{

	//
	public var settings:OceanParams;

	//
	public var grid:OceanGrid;

	// ------------- //

	//
	private var m_dispertion:OceanDispertion;

	//
	private var m_spectrum:OceanSpectrum;

	//
	private var m_fourier:FastFourierTransform;

	// ------------- //

	//
	private var m_spectrumBuffer:Vector<Vector<IVector2>>;

	//
	private var m_heightBuffer:Vector<Vector<IVector2>>;

	//
	private var m_slopeBuffer:Vector<Vector<IVector3>>;

	//
	private var m_displaceBuffer:Vector<Vector<IVector3>>;

	//
	private var m_signs:Vector<Float>;

	// ------------- //

	//
	private var m_tmp_v3:Vector3;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	//
	public function new( settings:OceanParams, grid:OceanGrid )
	{
		this.settings = settings;
		this.grid = grid;
	}

	// ************************************************************************ //
	// Initialize
	// ************************************************************************ //

	/**
	 *
	 */
	public function initialize():Void
	{
		this.m_dispertion 	= new OceanDispertion( this.settings );
		this.m_spectrum 	= new OceanSpectrum( this.settings );
		this.m_fourier		= new FastFourierTransform();

		this.m_signs = new Vector<Float>( 2 );
		this.m_signs[0] =  1.0;
		this.m_signs[1] = -1.0;

		this.m_tmp_v3 = new Vector3();
	}

	/**
	 *
	 */
	private function initializeBuffers():Void
	{
		var N1:Int = this.settings.N ;
		var N2:Int = Std.int( this.settings.N * this.settings.N );

		// ------------- //
		// spectrum:

		this.m_spectrumBuffer = new Vector<Vector<IVector2>>( N1 );

		for( j in 0...N1 )
		{
			this.m_spectrumBuffer[j] = new Vector<IVector2>( N1 );

			for( k in 0...N1 )
				this.m_spectrumBuffer[j][k] = new Vector2( 0, 0 );
		}

		// ------------- //

		this.m_heightBuffer 	= new Vector<Vector<IVector2>>( 2 );
		this.m_slopeBuffer 		= new Vector<Vector<IVector3>>( 2 );
		this.m_displaceBuffer 	= new Vector<Vector<IVector3>>( 2 );

		for( j in 0...2 )
		{
			this.m_heightBuffer[j] 	 = new Vector<IVector2>( N2 );
			this.m_slopeBuffer[j] 	 = new Vector<IVector3>( N2 );
			this.m_displaceBuffer[j] = new Vector<IVector3>( N2 );

			for( k in 0...N2 )
			{
				this.m_heightBuffer[j][k] 	= new Vector2( 0, 0 );
				this.m_slopeBuffer[j][k] 	= new Vector3( 0, 0, 0, 0 );
				this.m_displaceBuffer[j][k] = new Vector3( 0, 0, 0, 0 );
			}
		}

		// ------------- //

		this.m_dispertion.init();
		this.m_spectrum.init();

		this.m_fourier.initialize( N1 );
	}

	// ************************************************************************ //
	// Update
	// ************************************************************************ //

	/**
	 *
	 */
	public function update( time:Float ):Void
	{
		if( this.settings.isDimensionDirty )
		{
			this.initializeBuffers();					// allocates and updates everything
			this.settings.isDimensionDirty  = false;

		}
		else
		{
			if( this.settings.isDispertionDirty )
			{
				this.m_dispertion.update();
				this.settings.isDispertionDirty = false;
			}

			if( this.settings.isSpectrumDirty )
			{
				this.m_spectrum.update();
				this.settings.isSpectrumDirty = false;
			}

		}

		// -------------- //

		this.evaluateWaves( time );
		this.applyWave();
	}

	/**
	 *
	 */
	private function applyWave():Void
	{
		var N0:Int = this.settings.N;
		var N1:Int = this.settings.N + 1;

		// -------------------- //

		var data:Array<Float>;

		var norm:Vector3 = this.m_tmp_v3;
		var signs:Vector<Float> = this.m_signs;

		var sign:Float;

		var index0:Int;
		var index1:Int;
		var indexNN:Int;

		var lambda:Float 	= -1.0;
		var sharpness:Float =  1.0;

		// -------------------- //

		for( n in 0...N0 )
		{
			for( m in 0...N0 )
			{
				index0 = n * N0 + m;	// buffer index
				index1 = n * N1 + m;	// vertex index

				sign = signs[(n + m) & 1] * -1;

				// ------------ //
				// position:

				data = this.grid.mesh.getRegisterData( index1, RegisterHelper.V_POSITION );

				data[1] = this.m_heightBuffer[1][index0].x * sign;
				data[0] = this.grid.positions[index1].x + this.m_displaceBuffer[1][index0].x * lambda * sign * sharpness;
				data[2] = this.grid.positions[index1].y + this.m_displaceBuffer[1][index0].z * lambda * sign * sharpness;

				this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_POSITION, index1 );

				// ------------ //
				// normal:

				norm.y = 1.0;
				norm.x = this.m_slopeBuffer[1][index0].x * sign;
				norm.z = this.m_slopeBuffer[1][index0].z * sign;
				norm.normalize();

				data = this.grid.mesh.getRegisterData( index1, RegisterHelper.V_NORMAL );

				data[0] = norm.x;
				data[1] = norm.y;
				data[2] = norm.z;

				this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_NORMAL, index1 );

				// ------------ //
				// tiling

				if( n == 0 && m == 0)
				{
					indexNN = index1 + N0 + N1 * N0;

					// ------ //

					data = this.grid.mesh.getRegisterData( indexNN, RegisterHelper.V_POSITION );

					data[1] = this.m_heightBuffer[1][index0].x * sign;
					data[0] = this.grid.positions[indexNN].x + this.m_displaceBuffer[1][index0].x * lambda * sign * sharpness;
					data[2] = this.grid.positions[indexNN].y + this.m_displaceBuffer[1][index0].z * lambda * sign * sharpness;

					this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_POSITION, indexNN );

					// ------ //

					data = this.grid.mesh.getRegisterData( indexNN, RegisterHelper.V_NORMAL );

					data[0] = norm.x;
					data[1] = norm.y;
					data[2] = norm.z;

					this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_NORMAL, indexNN );
				}

				if( n == 0 )
				{
					indexNN = index1 + N1 * N0;

					// ------ //

					data = this.grid.mesh.getRegisterData( indexNN, RegisterHelper.V_POSITION );

					data[1] = this.m_heightBuffer[1][index0].x * sign;
					data[0] = this.grid.positions[indexNN].x + this.m_displaceBuffer[1][index0].x * lambda * sign * sharpness;
					data[2] = this.grid.positions[indexNN].y + this.m_displaceBuffer[1][index0].z * lambda * sign * sharpness;

					this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_POSITION, indexNN );

					// ------ //

					data = this.grid.mesh.getRegisterData( indexNN, RegisterHelper.V_NORMAL );

					data[0] =  norm.x;
					data[1] =  norm.y;
					data[2] =  norm.z;

					this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_NORMAL, indexNN );
				}

				if( m == 0)
				{
					indexNN = index1 + N0;

					// ------ //

					data = this.grid.mesh.getRegisterData( indexNN, RegisterHelper.V_POSITION );

					data[1] = this.m_heightBuffer[1][index0].x * sign;
					data[0] = this.grid.positions[indexNN].x + this.m_displaceBuffer[1][index0].x * lambda * sign * sharpness;
					data[2] = this.grid.positions[indexNN].y + this.m_displaceBuffer[1][index0].z * lambda * sign * sharpness;

					this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_POSITION, indexNN );

					// ------ //

					data = this.grid.mesh.getRegisterData( indexNN, RegisterHelper.V_NORMAL );

					data[0] =  norm.x;
					data[1] =  norm.y;
					data[2] =  norm.z;

					this.grid.mesh.setRegisterIndex( data, RegisterHelper.V_NORMAL, indexNN );
				}
			}
		}
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	private function evaluateWaves( time:Float ):Void
	{
		this.initWave( time );

		this.m_fourier.performFFT2( 0, this.m_heightBuffer 	);
		this.m_fourier.performFFT4( 0, this.m_slopeBuffer 	);
		this.m_fourier.performFFT4( 0, this.m_displaceBuffer );
	}

	/**
	 *
	 */
	private function initWave( t:Float ):Void
	{
		var N1:Int = this.settings.N;

		// -------------------- //

		var kx:Float;
		var ky:Float;

		var k_length:Float;
		var kx_scale:Float;
		var ky_scale:Float;

		var index:Int;
		var c_ht:IVector2;

		// -------------------- //



		for( n in 0...N1 )
		{
			kx = this.settings.getKComponent( n );

			for( m in 0...N1 )
			{
				ky = this.settings.getKComponent( m );

				// -------------- //
				// h(t)

				c_ht = this.ht( t, n, m );

				// -------------- //

				index = n * N1 + m;

				this.m_heightBuffer[1][ index ].x 	=  c_ht.x;
				this.m_heightBuffer[1][ index ].y 	=  c_ht.y;

				this.m_slopeBuffer[1][ index ].x 	= -c_ht.y * kx;
				this.m_slopeBuffer[1][ index ].y 	=  c_ht.x * kx;
				this.m_slopeBuffer[1][ index ].z 	= -c_ht.y * ky;
				this.m_slopeBuffer[1][ index ].w 	=  c_ht.x * ky;

				// -------------- //

				k_length = Math.sqrt( kx * kx + ky * ky );

				if( k_length < 0.00001 )
				{
					this.m_displaceBuffer[1][ index ].x = 0.0;
					this.m_displaceBuffer[1][ index ].y = 0.0;
					this.m_displaceBuffer[1][ index ].z = 0.0;
					this.m_displaceBuffer[1][ index ].w = 0.0;
				}
				else
				{
					kx_scale = -(kx / k_length);
					ky_scale = -(ky / k_length);

					this.m_displaceBuffer[1][ index ].x = -c_ht.y * kx_scale;
					this.m_displaceBuffer[1][ index ].y =  c_ht.x * kx_scale;
					this.m_displaceBuffer[1][ index ].z = -c_ht.y * ky_scale;
					this.m_displaceBuffer[1][ index ].w =  c_ht.x * ky_scale;
				}
			}
		}
	}

	/**
	 * h~(x,t) = h0(k) * exp( i * w(k) * t ) + h0'(-k) * exp( -i * w(k) * t );
	 */
	private function ht( t:Float, n:Int, m:Int ):IVector2
	{
		var w:Float = this.m_dispertion.dispertion[n][m] * t;

		var c_sin:Float = Math.sin( w );
		var c_cos:Float = Math.cos( w ); //Mathf.Sqrt( 1.0f - c_sin * c_sin ); // fast cos via phase shift

		var h01:IVector2 = this.m_spectrum.spectrum_norm[n][m];
		var h02:IVector2 = this.m_spectrum.spectrum_conj[n][m];

		var c_ht:IVector2 = this.m_spectrumBuffer[n][m];
			c_ht.x = ( h01.x * c_cos - h01.y * c_sin ) + ( h02.x * c_cos - h02.y * -c_sin ); 	// h0 * exp(i * w * t) + h0' * exp(-i * w * t)  ... -i!
			c_ht.y = ( h01.x * c_sin + h01.y * c_cos ) + ( h02.x * -c_sin + h02.y * c_cos ); 	// complex( x1*x2 - y1*y2, x1*y2 + y1*x2 ); ... euler sin/cos

		return c_ht;
	}
}