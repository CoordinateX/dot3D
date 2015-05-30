package haxe.at.dotpoint.dot3d.primitives;

import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.calculations.MeshCalculationTools;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshEditingTools;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshTriangle;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.SharedVertexPolicy;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.display.material.DiffuseColorMaterial;

/**
 * ...
 * @author RK
 */
class AxisTrident extends Sprite
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?length:Float = 1., ?thickness:Float = 0.1 ) 
	{	
		var shader:ShaderSignature 	= new ShaderSignature( "MeshColor", 1 );
		var mesh:IMeshData 			= new AxisTridentMesh( length, thickness );
		var material:IMaterial 		= new DiffuseColorMaterial();
		
		var triangles:Array<MeshTriangle> = MeshCalculationTools.calculateNormals( mesh, SharedVertexPolicy.SPLIT );		
		MeshEditingTools.addMeshTriangleList( mesh, triangles );
		
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
class AxisTridentMesh extends MeshData
{
	
	/**
	 * 
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	public function new( length:Float, thickness:Float ) 
	{
		super();	
		
		this.setupVertices( length, thickness * 0.5 );	
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
	private function setupVertices( l:Float, t:Float ):Void
	{		
		// X:
		this.addRegisterIndex( [  0, -t, -t ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  0, -t,  t ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  l, -t,  t ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  l, -t, -t ], RegisterHelper.V_POSITION  );
		
		this.addRegisterIndex( [  0.001,  t,  0 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  l,  t,  0 ], RegisterHelper.V_POSITION  );
		
		// Y:
		this.addRegisterIndex( [ -t,  0, -t ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -t,  0,  t ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -t,  l,  t ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -t,  l, -t ], RegisterHelper.V_POSITION  );
		
		this.addRegisterIndex( [  t,  0.001, 0  ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  t,  l,  0 ], RegisterHelper.V_POSITION  );
		
		// Z:
		this.addRegisterIndex( [ -t, -t,  0 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  t, -t,  0 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  t, -t,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -t, -t,  l ], RegisterHelper.V_POSITION  );
		
		this.addRegisterIndex( [  0,  t,  0.001 ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  0,  t,  l ], RegisterHelper.V_POSITION  );
		
		// ------------------ //
		// Normals:

		this.addRegisterIndex( [ 1., 0., 0. ], RegisterHelper.V_NORMAL ); 	// will be recalculated anyway ...
		
		// ------------------ //
		// Colors:

		this.addRegisterIndex( [ 1., 0., 0. ], RegisterHelper.V_COLOR ); 	// x: r
		this.addRegisterIndex( [ 0., 1., 0. ], RegisterHelper.V_COLOR ); 	// y: g
		this.addRegisterIndex( [ 0., 0., 1. ], RegisterHelper.V_COLOR ); 	// z: b
		
		
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	// FACE:
	
	/**
	 * 
	 */
	private function setupFaces():Void
	{	
		for( j in 0...3 )
		{
			var o:Int = j * 6;
			
			MeshEditingTools.addTriangleByVertexIndices( this, [0+o,0,j, 1+o,0,j, 2+o,0,j] );
			MeshEditingTools.addTriangleByVertexIndices( this, [2+o,0,j, 3+o,0,j, 0+o,0,j] );
			
			MeshEditingTools.addTriangleByVertexIndices( this, [1+o,0,j, 4+o,0,j, 5+o,0,j] );
			MeshEditingTools.addTriangleByVertexIndices( this, [5+o,0,j, 2+o,0,j, 1+o,0,j] );
			
			MeshEditingTools.addTriangleByVertexIndices( this, [0+o,0,j, 4+o,0,j, 5+o,0,j] );
			MeshEditingTools.addTriangleByVertexIndices( this, [5+o,0,j, 3+o,0,j, 0+o,0,j] );
			
			MeshEditingTools.addTriangleByVertexIndices( this, [5+o,0,j, 2+o,0,j, 3+o,0,j] );
			MeshEditingTools.addTriangleByVertexIndices( this, [4+o,0,j, 0+o,0,j, 1+o,0,j] );
		}
		
	}
}