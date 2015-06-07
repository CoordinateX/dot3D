package flash.at.dotpoint.dot3d.shader;

import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShader;
import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShaderContext;
import flash.display3D.Context3DTriangleFace;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.dot3d.rendering.renderable.Texture;
import haxe.at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

class TLineShader extends Shader
{
	static var SRC = 
	{
		var thickness:Float;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		
		var input: 
		{
			V_POSITION:Float3,
			V_DIRECTION:Float3,
			V_SIGN:Float,	
			V_COLOR:Float3,	
		};	
		
		var vcolor:Float3;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( E_MODEL2WORLD_TRANSFORM:M44, W_WORLD2CAMERA_TRANSFORM:M44, W_CAMERA_POSITION:Float3 ) 
		{
			var v = input.V_POSITION.xyzw * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;
			var p = input.V_DIRECTION.xyzw * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;
			
			// ----------- //
			
			var c = [ 0, 0, 1 ];		
			var d = norm( v.xyz - p.xyz );
			
			var n = norm( cross( d, c ) );
			
			var k = [0, 1, 0, 0];	// [0, 1, 0, 0] = no normal at all .... so n.y is always 0
				k.xyz = n.xyz * input.V_SIGN * thickness;
			
			// ----------- //	
			
			vcolor = input.V_COLOR;			
			out = (v  +  k);
		}
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:
		
		function fragment() 
		{		
			var c = [0, 0, 0, 0];
				c.xyz = vcolor.xyz;
			
			out = c; // diffuseColor;
		}
	};
}

/**
 * ...
 * @author RK
 */
class LineShader extends Flash3DShader
{

	/**
	 * 
	 */
	private var shader:TLineShader;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{			
		super();
		
		this.shader 		= new TLineShader();
		this.contextSetting = new Flash3DShaderContext();		
		this.signature 		= this.generateShaderSignature( "line" );		
		
		this.contextSetting.culling = Context3DTriangleFace.NONE;		
		this.shader.thickness = 0.1;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public override function getInternalShader():TLineShader 
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
		if( type.ID == RegisterHelper.W_CAMERA_POSITION.ID )
			this.shader.W_CAMERA_POSITION = cast data;	
		
		if( type.ID == RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
			this.shader.W_WORLD2CAMERA_TRANSFORM = cast data;				
		
		if( type.ID == RegisterHelper.E_MODEL2WORLD_TRANSFORM.ID )
			this.shader.E_MODEL2WORLD_TRANSFORM = cast data;
	}
}