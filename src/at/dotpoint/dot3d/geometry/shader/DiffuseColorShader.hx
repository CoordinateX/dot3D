package at.dotpoint.dot3d.geometry.shader;

import at.dotpoint.display.register.RegisterHelper;
import at.dotpoint.display.register.RegisterType;
import at.dotpoint.display.rendering.shader.ShaderSignature;
import at.dotpoint.dot3d.render.shader.Stage3DShader;
import at.dotpoint.dot3d.render.shader.Stage3DShaderContext;
import at.dotpoint.math.vector.IMatrix44;
import at.dotpoint.math.vector.IVector3;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Vector3;
import flash.display3D.Context3DTriangleFace;
import hxsl.Shader;

class TDiffuseColorShader extends Shader
{
	static var SRC = 
	{
		var M_COLOR:Float4;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		
		var input: 
		{
			V_POSITION:Float3,
			V_NORMAL:Float3,	
			V_UV_COORDINATES:Float2,					
		};			
		
		var lpow:Float;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( E_MODEL2WORLD_TRANSFORM:M44, W_WORLD2CAMERA_TRANSFORM:M44, light:Float3 ) 
		{
			out = input.V_POSITION.xyzw * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;			
			lpow = light.dot( (input.V_NORMAL * E_MODEL2WORLD_TRANSFORM).normalize() ).max(0);
		}
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:
		
		function fragment() 
		{
			out = M_COLOR * (lpow * 0.8 + 0.2);			
		}
	};
}

/**
 * ...
 * @author RK
 */
class DiffuseColorShader extends Stage3DShader
{

	/**
	 * 
	 */
	private var shader:TDiffuseColorShader;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{			
		super();
		
		this.shader 		= new TDiffuseColorShader();
		this.contextSetting = new Stage3DShaderContext();		
		this.signature 		= this.generateShaderSignature( "DiffuseColor" );		
		
		this.contextSetting.culling = Context3DTriangleFace.NONE;
		
		var l:Vector3 = new Vector3( 3, 2, -1 );
			l.normalize();
		
		this.shader.light = l;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public override function getInternalShader():TDiffuseColorShader 
	{
		return this.shader;
	}
	
	/**
	 * 
	 * @param	type
	 * @param	data
	 */
	override public function setRegisterData( type:RegisterType, data:Dynamic ):Void 
	{
		if( type.ID == RegisterHelper.M_COLOR.ID )
			this.shader.M_COLOR = cast data;
		
		if( type.ID == RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
			this.shader.W_WORLD2CAMERA_TRANSFORM = cast data;				
		
		if( type.ID == RegisterHelper.E_MODEL2WORLD_TRANSFORM.ID )
			this.shader.E_MODEL2WORLD_TRANSFORM = cast data;		
	}
}