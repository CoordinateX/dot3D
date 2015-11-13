package lwjgl.at.dotpoint.dot3d.rendering.renderable;
import haxe.at.dotpoint.core.dispatcher.lazy.LazyStatus;
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
import haxe.at.dotpoint.math.vector.IVector3;
import lwjgl.at.dotpoint.dot3d.rendering.Java3DRenderer;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShaderProgram;

/**
 * ...
 * @author RK
 */
@:access(haxe.at.dotpoint.display.renderable.geometry.material.IMaterial)
@:access(haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData)
//
class Java3DRenderable extends ARenderable<IDisplayObject,ModelRenderData> implements IEntityRenderer<IDisplayObject>
{

	/**
	 *
	 */
	public var shader:Java3DShaderProgram;

	/**
	 *
	 */
	public var mesh:Java3DMeshBuffer;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( shader:Java3DShaderProgram, mesh:Java3DMeshBuffer )
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

		var renderer:Java3DRenderer = Stage3DEngine.instance.getRenderer();
			renderer.selectShader( this.shader );
		//	renderer.selectShaderContext( this.shader.contextSetting );
			renderer.selectMesh( this.model.mesh, this.mesh );

		this.applyShaderInput();

		renderer.drawTriangles();
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

		var camera:IVector3 = Stage3DEngine.instance.getScene().getRegisterData( this.entity, RegisterHelper.W_CAMERA_POSITION );
		this.shader.setRegisterData( RegisterHelper.W_CAMERA_POSITION, camera );

		var light:IVector3 = Stage3DEngine.instance.getScene().getRegisterData( this.entity, RegisterHelper.W_LIGHT_DIRECTIONAL );
		this.shader.setRegisterData( RegisterHelper.W_LIGHT_DIRECTIONAL, light );
	}

}