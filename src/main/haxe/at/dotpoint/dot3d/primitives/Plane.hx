package haxe.at.dotpoint.dot3d.primitives;

import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.lookup.MeshDataHashLookup;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshEditingTools;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.display.material.DiffuseColorMaterial;

/**
 * ...
 * @author RK
 */
class Plane extends Sprite
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( ?w:Float = 1, ?h:Float = 1, segmentsX:Int = 1, segmentsY:Int = 1 )
	{
		var shader:ShaderSignature 	= new ShaderSignature( "DiffuseColor", 1 );
		var mesh:IMeshData 			= new PlaneMesh( w, h, segmentsX, segmentsY );
		var material:IMaterial 		= new DiffuseColorMaterial();

		super( new ModelRenderData( shader, mesh, material ) );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //
}

/**
 * ...
 * @author RK
 */
class PlaneMesh extends MeshData
{

	/**
	 *
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	public function new( w:Float, h:Float, segmentsX:Int = 1, segmentsY:Int = 1 )
	{
		var lookup:MeshDataHashLookup = new MeshDataHashLookup();
			lookup.ignoreLookup.push( RegisterHelper.V_NORMAL );
			lookup.ignoreLookup.push( RegisterHelper.V_POSITION );
			lookup.ignoreLookup.push( RegisterHelper.V_UV_COORDINATES );

		super( lookup );

		if( segmentsX <= 0 ) segmentsX = 1;
		if( segmentsY <= 0 ) segmentsY = 1;

		this.setupVertices( w, h, segmentsX, segmentsY );
		this.setupFaces( w, h, segmentsX, segmentsY );
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	private function setupVertices( w:Float, h:Float, segmentsX:Int, segmentsY:Int ):Void
	{
		var xfactor:Float = w / segmentsX;
		var yfactor:Float = h / segmentsY;

		var xscale:Int = segmentsX + 1;
		var yscale:Int = segmentsY + 1;

		for( xs in 0...xscale )
		{
			var x:Float = -w * 0.5 + xs * xfactor;
			var u:Float = xs / segmentsX;

			for( ys in 0...yscale )
			{
				var index:Int = ys + xs * yscale;

				var y:Float = -h * 0.5 + ys * yfactor;
				var v:Float = ys / segmentsY;

				this.setRegisterIndex( [ x, 0., y ], 	RegisterHelper.V_POSITION, 			index );
				this.setRegisterIndex( [ u, v ], 		RegisterHelper.V_UV_COORDINATES, 	index );
				this.setRegisterIndex( [ 0., 1., 0. ], 	RegisterHelper.V_NORMAL, 			index );
			}
		}
	}

	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:

	/**
	 *
	 */
	private function setupFaces( w:Float, h:Float, segmentsX:Int, segmentsY:Int ):Void
	{
		var xscale:Int = segmentsX + 1;
		var yscale:Int = segmentsY + 1;

		for( x in 0...segmentsX )
		{
			for( y in 0...segmentsY )
			{
				var x0:Int = (x+0) * yscale + (y+0);
				var x1:Int = (x+0) * yscale + (y+1);
				var x2:Int = (x+1) * yscale + (y+0);
				var x3:Int = (x+1) * yscale + (y+1);

				var t0:Int = MeshEditingTools.addTriangleByVertexIndices( this, [x2,x2,x2, x0,x0,x0, x1,x1,x1] );
				var t1:Int = MeshEditingTools.addTriangleByVertexIndices( this, [x1, x1, x1, x3, x3, x3, x2, x2, x2] );
			}
		}
	}
}