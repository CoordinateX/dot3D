package at.dotpoint.dot3d.render.renderable;

import at.dotpoint.core.entity.Component;
import at.dotpoint.display.DisplayEngine;
import at.dotpoint.display.geometry.material.IMaterial;
import at.dotpoint.display.geometry.material.MaterialSignature;
import at.dotpoint.display.geometry.mesh.IMeshData;
import at.dotpoint.display.IDisplayObject;
import at.dotpoint.display.register.RegisterHelper;
import at.dotpoint.display.rendering.renderable.IRenderable;
import at.dotpoint.display.rendering.shader.IShader;
import at.dotpoint.dot3d.render.shader.Stage3DShader;
import at.dotpoint.dot3d.render.Stage3DRenderer;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.IMatrix44;

/**
 * ...
 * @author RK
 */
class Stage3DRenderable extends Component<IDisplayObject> implements IRenderable<IDisplayObject>
{

	/**
	 * 
	 */
	public var meshBuffer:Stage3DMeshBuffer;
	
	/**
	 * 
	 */
	public var shader:Stage3DShader;
	
	/**
	 * 
	 */
	public var renderer:Stage3DRenderer;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( shader:Stage3DShader, buffer:Stage3DMeshBuffer, ?renderer:Stage3DRenderer ) 
	{
		super();
		
		this.shader 	= shader;
		this.meshBuffer = buffer;		
		this.renderer	= renderer != null ? renderer : cast DisplayEngine.renderer;
	}
	
	// ************************************************************************ //
	// getter
	// ************************************************************************ //	
	
	public function getMaterial():IMaterial 
	{
		return this.entity.getModel().material;
	}
	
	public function getMesh():IMeshData 
	{
		return this.entity.getModel().mesh;
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
		if( this.shader == null || this.meshBuffer == null || this.renderer == null )
			throw "Renderable not setup correctly";
		
		// --------------- //
		
		this.applyShaderInput();
		
		this.renderer.selectShader( this.shader );			
		this.renderer.selectShaderContext( this.shader.contextSetting );
		this.renderer.selectMesh( this.getMesh(), this.meshBuffer );
		
		this.renderer.getContext3D().drawTriangles( this.meshBuffer.indexBuffer );
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
		var material:IMaterial = this.getMaterial();
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
		var projection:IMatrix44 = this.renderer.getScene().getRegisterData( this.entity, RegisterHelper.W_WORLD2CAMERA_TRANSFORM );		
		this.shader.setRegisterData( RegisterHelper.W_WORLD2CAMERA_TRANSFORM, projection );		
	}
	
}