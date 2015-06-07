package haxe.at.dotpoint.dot3d.renderable;

import haxe.at.dotpoint.display.material.DiffuseColorMaterial;
import haxe.at.dotpoint.display.renderable.DisplayObject;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshEditingTools;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshRegisterData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshVertex;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.MeshIndices.MeshIndexRegister;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.MeshIndices.MeshIndexVertex;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class Shape extends Sprite
{

	private var c_pos:MeshIndexRegister;
	private var c_dir:MeshIndexRegister;
	private var c_col:MeshIndexRegister;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		var shader:ShaderSignature 	= new ShaderSignature( "line", 4 );
		var mesh:IMeshData 			= new MeshData();
		var material:IMaterial 		= new DiffuseColorMaterial();
		
		var model:ModelRenderData = new ModelRenderData( shader, mesh, material );
		
		super( model );
		
		this.c_pos = -1;
		this.c_dir = -1;
		this.c_col = -1;
		
		this.addSigns();
	}	
	
	private function addSigns():Void
	{
		var model:ModelRenderData = this.getComponent( ModelRenderData );
			model.mesh.addRegisterIndex( [-0.5], RegisterHelper.V_SIGN  );
			model.mesh.addRegisterIndex( [ 0.5], RegisterHelper.V_SIGN  );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * start a new set without drawing a line similar to flash.graphics.moveTo
	 * position must be 3 values (x,y,z) and color aswell (r,g,b)
	 */
	public function moveTo( pos:Array<Float>, color:Array<Float> ):Void
	{
		var model:ModelRenderData = this.getComponent( ModelRenderData );
		
		this.c_pos = model.mesh.addRegisterIndex( pos, 		RegisterHelper.V_POSITION   );
		this.c_dir = model.mesh.addRegisterIndex( pos, 		RegisterHelper.V_DIRECTION  );	
		this.c_col = model.mesh.addRegisterIndex( color, 	RegisterHelper.V_COLOR 		);	
	}
	
	/**
	 * creates a line from the previous position to the given one similar to flash.graphics.lineTo
	 * position must be 3 values (x,y,z) and color aswell (r,g,b)
	 */
	public function lineTo( pos:Array<Float>, color:Array<Float> ):Void
	{			
		if( this.c_pos == -1 )
			throw "must call moveTo first";		
		
		// -------------- //
		
		var p_pos:MeshIndexRegister = this.c_pos;
		var p_dir:MeshIndexRegister = this.c_dir;
		var p_col:MeshIndexRegister = this.c_col;
		
		this.moveTo( pos, color );
		
		// -------------- //
		
		var model:ModelRenderData = this.getComponent( ModelRenderData );
		
		var p0:MeshIndexVertex = model.mesh.addVertexIndex( [c_pos, p_dir, 0, c_col] );	
		var p1:MeshIndexVertex = model.mesh.addVertexIndex( [c_pos, p_dir, 1, c_col] );
		
		var c0:MeshIndexVertex = model.mesh.addVertexIndex( [p_pos, c_dir, 0, p_col] );	
		var c1:MeshIndexVertex = model.mesh.addVertexIndex( [p_pos, c_dir, 1, p_col] );	
			
		// -------------- //		
		
		model.mesh.addTriangleIndex( [p0, p1, c0] );
		model.mesh.addTriangleIndex( [c0, c1, p0] );			
	}
}