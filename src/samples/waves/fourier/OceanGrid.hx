package fourier;
import haxe.at.dotpoint.display.material.DiffuseColorMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.lookup.MeshDataHashLookup;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshEditingTools;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.dot3d.primitives.Plane;
import haxe.at.dotpoint.math.color.ColorUtil;
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
			segments = settings.N + 1;

		this.patches = new Vector<IDisplayObject>( numX * numY );

		this.mesh 		= this.createMesh( settings, segments );
		this.shader 	= new ShaderSignature( "DiffuseColor", 1 );
		this.material 	= new DiffuseColorMaterial( ColorUtil.toVector( 0x63A9B8 ) );

		this.createPatches( numX, numY, settings );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	settings
	 * @param	segments
	 */
	private function createMesh( settings:OceanParams, segments:Int ):IMeshData
	{
		this.positions = new Vector<IVector2>( segments * segments );

		var lookup:MeshDataHashLookup = new MeshDataHashLookup();
			lookup.ignoreLookup.push( RegisterHelper.V_NORMAL );
			lookup.ignoreLookup.push( RegisterHelper.V_POSITION );
			lookup.ignoreLookup.push( RegisterHelper.V_UV_COORDINATES );

		var mesh:MeshData = new MeshData( lookup );

		// ------------------------ //

		var w:Float = segments * settings.N / settings.L;
		var h:Float = segments * settings.N / settings.L;

		for( x in 0...segments )
		{
			for( y in 0...segments )
			{
				var index:Int = x * segments + y;

				var xp:Float = x * settings.N / settings.L;
				var zp:Float = y * settings.N / settings.L;

				mesh.setRegisterIndex( [ xp, 0, zp ], 		RegisterHelper.V_POSITION, 			index );
				mesh.setRegisterIndex( [ xp / w, zp / h ], 	RegisterHelper.V_UV_COORDINATES, 	index );
				mesh.setRegisterIndex( [ 0, 1, 0 ], 		RegisterHelper.V_NORMAL, 			index );

				mesh.setVertexIndex( [ index, index, index ], index );

				this.positions[index] = new Vector2( xp, zp );
			}
		}

		for( x in 0...segments-1 )
		{
			for( y in 0...segments-1 )
			{
				var x0:Int = ( x + 1 ) + ( y + 0 ) * segments;
				var x1:Int = ( x + 1 ) + ( y + 1 ) * segments;
				var x2:Int = ( x + 0 ) + ( y + 1 ) * segments;
				var x3:Int = ( x + 0 ) + ( y + 0 ) * segments;

				mesh.addTriangleIndex( [ x0, x1, x2] );
				mesh.addTriangleIndex( [ x0, x2, x3] );
			}
		}

		// ------------------------ //

		return mesh;
	}

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

}