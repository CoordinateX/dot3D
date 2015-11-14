package fourier;
import haxe.at.dotpoint.display.material.DiffuseColorMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.dot3d.primitives.Plane;
import haxe.at.dotpoint.math.vector.IVector2;
import haxe.at.dotpoint.math.vector.Vector2;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class OceanGrid
{

	/**
	 * grid / patch table of ocean game objects
	 */
	public var patches:Vector<IDisplayObject>;

	/**
	 * original position
	 */
	public var positions:Vector<IVector2>;

	/**
	 * single ocean patch which is tiled several times
	 */
	public var mesh:IMeshData;
	public var material:IMaterial;
	public var shader:ShaderSignature;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( settings:OceanParams, numX:Int = 1, numY:Int = 1, segments:Int = -1  )
	{
		if( segments <= -1 )
			segments = settings.N;

		this.patches = new Vector<IDisplayObject>( numX * numY );

		this.mesh 		= new PlaneMesh( 1, 1, segments, segments );
		this.shader 	= new ShaderSignature( "DiffuseColor", 1 );
		this.material 	= new DiffuseColorMaterial();

		this.createPatches( numX, numY, settings );
		this.updatePositions( segments, settings );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	numX
	 * @param	numY
	 * @param	size
	 * @param	settings
	 */
	private function createPatches( numX:Int, numY:Int, settings:OceanParams ):Void
	{
		var counter:Int = 0;

		for( x in 0...numX )
		{
			for( y in 0...numY )
			{
				var patch:Sprite = new Sprite( new ModelRenderData( this.shader, this.mesh, this.material ) );
					patch.transform.position.x = x * settings.L - numX * settings.L / 2;
					patch.transform.position.z = y * settings.L - numY * settings.L / 2;

				this.patches[counter++] = patch;
			}
		}
	}

	/**
	 *
	 */
	private function updatePositions( segments:Int, settings:OceanParams ):Void
	{
		segments += 1;
		this.positions = new Vector<IVector2>( segments * segments );

		for( n in 0...segments )
		{
			for( m in 0...segments )
			{
				var index:Int = n * segments + m;

				var x:Float = n * settings.N / settings.L;
				var z:Float = m * settings.N / settings.L;

				this.mesh.setRegisterIndex( [ x, 0.0, z ], RegisterHelper.V_POSITION, index );
				this.positions[index] = new Vector2( x, z );
			}
		}
	}
}