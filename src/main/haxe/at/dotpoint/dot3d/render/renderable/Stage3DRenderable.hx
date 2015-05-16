package haxe.at.dotpoint.dot3d.render.renderable;

import haxe.at.dotpoint.core.entity.Component;
import haxe.at.dotpoint.display.DisplayEngine;
import haxe.at.dotpoint.display.geometry.material.IMaterial;
import haxe.at.dotpoint.display.geometry.material.MaterialSignature;
import haxe.at.dotpoint.display.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.geometry.ModelRenderData;
import haxe.at.dotpoint.display.IDisplayObject;
import haxe.at.dotpoint.display.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.renderable.IEntityRenderer;
import haxe.at.dotpoint.display.rendering.shader.IShader;
import haxe.at.dotpoint.dot3d.render.shader.Stage3DShader;
import haxe.at.dotpoint.dot3d.render.Stage3DRenderer;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.math.geom.Space;
import haxe.at.dotpoint.math.vector.IMatrix44;

/**
 * ...
 * @author RK
 */
class Stage3DRenderable extends Component<IDisplayObject> implements IEntityRenderer<IDisplayObject>
{
	
	/**
	 * 
	 */
	public var engine:DisplayEngine;
	
	/**
	 * 
	 */
	public var shader:Stage3DShader;
	
	// ------------- //
	
	/**
	 * 
	 */
	public var buffer:Stage3DMeshBuffer;
	
	/**
	 * 
	 */
	public var model:ModelRenderData;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( shader:Stage3DShader, buffer:Stage3DMeshBuffer ) 
	{
		super();
		
		this.shader = shader;
		this.buffer = buffer;		
	}
	
	// ************************************************************************ //
	// Entity
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	override function onEntityAdded():Void 
	{
		this.model = this.entity.getComponent( ModelRenderData );
	}
	
	/**
	 * 
	 */
	override function onEntityRemoved():Void 
	{
		this.model = null;
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
		if( this.shader == null || this.buffer == null )
			throw "Renderable not setup correctly";
		
		// --------------- //
		
		this.applyShaderInput();
		
		var renderer:Stage3DRenderer = Stage3DEngine.instance.getRenderer();		
			renderer.selectShader( this.shader );			
			renderer.selectShaderContext( this.shader.contextSetting );
			renderer.selectMesh( this.model.mesh, this.buffer );		
			renderer.getContext3D().drawTriangles( this.buffer.indexBuffer );
	}
	
	// ************************************************************************ //
	// Helper
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function applyShaderInput():Void
	{
		this.applyMaterialInput();
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
	}
	
	/**
	 * 
	 */
	private function applyEntityInput():Void 
	{
		var transform:IMatrix44 = this.entity.transform.getMatrix( null, Space.WORLD );			
		this.shader.setRegisterData( RegisterHelper.E_MODEL2WORLD_TRANSFORM, transform );		
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