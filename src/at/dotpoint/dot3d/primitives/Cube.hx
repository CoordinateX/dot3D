package at.dotpoint.dot3d.primitives;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.display.geometry.material.IMaterial;
import at.dotpoint.display.geometry.mesh.IMeshData;
import at.dotpoint.display.geometry.mesh.MeshData;
import at.dotpoint.display.geometry.mesh.util.editing.MeshEditingTools;
import at.dotpoint.display.geometry.ModelRenderData;
import at.dotpoint.display.register.RegisterHelper;
import at.dotpoint.display.rendering.shader.ShaderSignature;
import at.dotpoint.display.Sprite;
import at.dotpoint.dot2d.geometry.material.DiffuseColorMaterial;

/**
 * ...
 * @author RK
 */
class Cube extends Sprite
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?w:Float = 1, ?h:Float = 1, ?l:Float = 1 ) 
	{	
		var shader:ShaderSignature 	= new ShaderSignature( "DiffuseColor", 1 );
		var mesh:IMeshData 			= new CubeMesh( w, h, l );
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
class CubeMesh extends MeshData
{
	
	/**
	 * 
	 * @param	w
	 * @param	h
	 * @param	l
	 */
	public function new( w:Float, h:Float, l:Float ) 
	{
		super();
		
		w = w * 0.5;
		h = h * 0.5;
		l = l * 0.5;		
		
		this.setupVertices( w, h, l );	
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
	private function setupVertices( w:Float, h:Float, l:Float ):Void
	{
		this.addRegisterIndex( [ -w, -h, -l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -w,  h, -l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  w,  h, -l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  w, -h, -l ], RegisterHelper.V_POSITION  );
		
		this.addRegisterIndex( [ -w, -h,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  w, -h,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [  w,  h,  l ], RegisterHelper.V_POSITION  );
		this.addRegisterIndex( [ -w,  h,  l ], RegisterHelper.V_POSITION  );
		
		// ------------------ //
		// UV:

		this.addRegisterIndex( [ 1., 0. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterIndex( [ 1., 1. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterIndex( [ 0., 1. ], RegisterHelper.V_UV_COORDINATES );
		this.addRegisterIndex( [ 0., 0. ], RegisterHelper.V_UV_COORDINATES );
		
		// ------------------ //
		// Normal:

		this.addRegisterIndex( [  0.,  0., -1. ], RegisterHelper.V_NORMAL );
		this.addRegisterIndex( [  0.,  0.,  1. ], RegisterHelper.V_NORMAL );
		this.addRegisterIndex( [  0., -1.,  0. ], RegisterHelper.V_NORMAL );
		
		this.addRegisterIndex( [  1.,  0.,  0. ], RegisterHelper.V_NORMAL );
		this.addRegisterIndex( [  0.,  1.,  0. ], RegisterHelper.V_NORMAL );
		this.addRegisterIndex( [ -1.,  0.,  0. ], RegisterHelper.V_NORMAL );
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
		
		MeshEditingTools.addTriangleByVertexIndices( this, [4,3,1, 5,0,1, 6,1,1] );
		MeshEditingTools.addTriangleByVertexIndices( this, [6,1,1, 7,2,1, 4,3,1] );
		
		MeshEditingTools.addTriangleByVertexIndices( this, [0,3,2, 3,0,2, 5,1,2] );
		MeshEditingTools.addTriangleByVertexIndices( this, [5,1,2, 4,2,2, 0,3,2] );
		
		MeshEditingTools.addTriangleByVertexIndices( this, [3,3,3, 2,0,3, 6,1,3] );
		MeshEditingTools.addTriangleByVertexIndices( this, [6,1,3, 5,2,3, 3,3,3] );
		
		MeshEditingTools.addTriangleByVertexIndices( this, [2,3,4, 1,0,4, 7,1,4] );
		MeshEditingTools.addTriangleByVertexIndices( this, [7,1,4, 6,2,4, 2,3,4] );
		
		MeshEditingTools.addTriangleByVertexIndices( this, [1,3,5, 0,0,5, 4,1,5] );
		MeshEditingTools.addTriangleByVertexIndices( this, [4,1,5, 7,2,5, 1,3,5] );
	}
}