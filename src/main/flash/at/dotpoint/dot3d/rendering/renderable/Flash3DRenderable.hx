package flash.at.dotpoint.dot3d.rendering.renderable;

import flash.at.dotpoint.dot3d.rendering.Flash3DRenderer;
import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShader;
import haxe.at.dotpoint.core.lazy.LazyStatus;
import haxe.at.dotpoint.display.DisplayEngine;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.MaterialSignature;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.renderable.ARenderable;
import haxe.at.dotpoint.display.rendering.renderable.IEntityRenderer;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.math.geom.Space;
import haxe.at.dotpoint.math.vector.IMatrix44;

/**
 * ...
 * @author RK
 */
@:access(haxe.at.dotpoint.display.renderable.geometry.material.IMaterial)
@:access(haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData)
//
class Flash3DRenderable extends ARenderable<IDisplayObject,ModelRenderData> implements IEntityRenderer<IDisplayObject>
{
	
	/**
	 * 
	 */
	public var shader:Flash3DShader;	
	
	/**
	 * 
	 */
	public var mesh:Flash3DMeshBuffer;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( shader:Flash3DShader, mesh:Flash3DMeshBuffer ) 
	{
		super();
		
		this.shader 	= shader;
		this.mesh 		= mesh;		
	}
	
	// ************************************************************************ //
	// Render
	// ************************************************************************ //		
	
	/**
	 * 
	 * @param	entity
	 */
	public function render():Void
	{
		if( this.shader == null || this.mesh == null )
			throw "Renderable not setup correctly";
		
		// --------------- //
		
		this.applyShaderInput();
		
		var renderer:Flash3DRenderer = Stage3DEngine.instance.getRenderer();		
			renderer.selectShader( this.shader );			
			renderer.selectShaderContext( this.shader.contextSetting );
			renderer.selectMesh( this.model.mesh, this.mesh );		
		
		renderer.getContext3D().drawTriangles( this.mesh.indexBuffer );
	}
	
	// ************************************************************************ //
	// Helper
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function applyShaderInput():Void
	{
		if( this.model.material.lazy.status == LazyStatus.INVALID )
			this.applyMaterialInput();
		
		if( this.statusTransform == LazyStatus.INVALID )	
			this.applyEntityInput();
		
		this.applySceneInput();
	}
	
	/**
	 * 
	 */
	private function applyMaterialInput():Void 
	{
		var material:IMaterial = this.model.material;
		var signature:MaterialSignature = material.getMaterialSignature();
		
		for( register in signature )
		{
			this.shader.setRegisterData( register, material.getRegisterData( register ) );
		}
		
		this.model.material.lazy.validate();
	}
	
	/**
	 * 
	 */
	private function applyEntityInput():Void 
	{
		var transform:IMatrix44 = this.entity.transform.getMatrix( null, Space.WORLD );			
		this.shader.setRegisterData( RegisterHelper.E_MODEL2WORLD_TRANSFORM, transform );	
		
		this.statusTransform = LazyStatus.VALID;
	}
	
	/**
	 * 
	 */
	private function applySceneInput():Void 
	{
		var projection:IMatrix44 = Stage3DEngine.instance.getScene().getRegisterData( this.entity, RegisterHelper.W_WORLD2CAMERA_TRANSFORM );		
		this.shader.setRegisterData( RegisterHelper.W_WORLD2CAMERA_TRANSFORM, projection );		
	}
	
}