package at.dotpoint.dot3d.geometry.shader;

import at.dotpoint.display.register.RegisterHelper;
import at.dotpoint.display.register.RegisterType;
import at.dotpoint.display.rendering.shader.ShaderSignature;
import at.dotpoint.dot3d.render.shader.Stage3DShader;
import at.dotpoint.dot3d.render.shader.Stage3DShaderContext;
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
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( E_MODEL2WORLD_TRANSFORM:M44, W_WORLD2CAMERA_TRANSFORM:M44 ) 
		{
			out = input.V_POSITION.xyzw * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;		
		}
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:
		
		function fragment() 
		{
			out = M_COLOR;			
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