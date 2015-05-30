package haxe.at.dotpoint.dot3d.primitives;

import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshEditingTools;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
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
	
	public function new( ?w:Float = 1, ?h:Float = 1 ) 
	{	
		var shader:ShaderSignature 	= new ShaderSignature( "DiffuseColor", 1 );
		var mesh:IMeshData 			= new PlaneMesh( w, h );
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
	public function new( w:Float, h:Float ) 
	{
		super();
		
		w = w * 0.5;
		h = h * 0.5;	
		
		this.setupVertices( w, h );	
		this.setupFaces();
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
	private function setupVertices( w:Float, h:Float ):Void
	{
		this.addRegisterIndex( [ -w, -h, 0 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -w,  h, 0 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  w,  h, 0 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  w, -h, 0 ], RegisterHelper.V_POSITION  );
		
		// ------------------ //
		// UV:
		
		this.addRegisterIndex( [ 1., 0. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterIndex( [ 1., 1. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterIndex( [ 0., 1. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterIndex( [ 0., 0. ], RegisterHelper.V_UV_COORDINATES );
		
		// ------------------ //
		// Normal:
		
		this.addRegisterIndex( [  0.,  0.,  1. ], RegisterHelper.V_NORMAL );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces():Void
	{		
		MeshEditingTools.addTriangleByVertexIndices( this, [0,0,0, 1,1,0, 2,2,0] );
		MeshEditingTools.addTriangleByVertexIndices( this, [2,2,0, 3,3,0, 0,0,0] );		
	}
}