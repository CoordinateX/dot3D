package at.dotpoint.dot3d.shader;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.ShaderInput;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.math.color.ColorFormat;
import at.dotpoint.math.color.ColorFormat;
import at.dotpoint.math.color.ColorUtil;
import at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

/**
 * ...
 * @author Gerald Hattensauer
 */
class TShader extends Shader
{
	static var SRC = 
	{
		var ambientColor:Float4;
		var diffuseColor:Float4;
		var specularColor:Float4;
		
		var specularWeight:Float;
		var alpha:Float;
		
		var useTexture:Bool;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		
		var input: 
		{
			pos:Float3,
			uv:Float2,
			normal:Float3,			
		};	
		
		var tuv:Float2;
		var lpow:Float;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( mpos:M44, mproj:M44, light:Float3 ) 
		{
			out = input.pos.xyzw * mpos * mproj;		
			
			lpow = light.dot( (input.normal * mpos).normalize() ).max(0);			
			tuv = input.uv;
		}
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:
		
		function fragment( ambient:Texture, diffuse:Texture, normal:Texture ) 
		{
			if ( useTexture )
			{
				out = diffuse.get(tuv) * (lpow * 0.8 + 0.2);
			}
			else
			{
				out = diffuseColor * (lpow * 0.8 + 0.2);
			}
		}
	};
}

/**
 * 
 */
class TestShader extends Material<TShader>
{

	public var ambientColor(get,set):Vector3;
	public var diffuseColor(get, set):Vector3;	
	public var specularColor(get, set):Vector3;
	
	public var specularWeight(get,set):Float;
	public var alpha(get,set):Float;
	
	public var ambientMap(get,set):Texture;
	public var diffuseMap(get,set):Texture;
	public var normalMap(get, set):Texture;
	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new()
	{
		var shader:TShader = new TShader();	
			shader.useTexture = false;
		
		super( shader );	
		
		this.diffuseColor = ColorUtil.toVector( Std.int( Math.random() * 0xFFFFFF ), ColorFormat.RGB );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	input
	 */
	public override function applyInput( shaderInput:ShaderInput  ):Void 
	{
		for( regin in shaderInput.values )
		{
			switch( regin.type )
			{
				case "mpos":
				{
					if( this.shader.mpos != regin.input )
						this.shader.mpos = regin.input;
				}
				
				case "mproj":
				{
					if( this.shader.mproj != regin.input )
						this.shader.mproj = regin.input;
				}
					
				case "light":
				{
					if( this.shader.light != regin.input )
						this.shader.light = regin.input;
				}	
				
				default:
					throw "ShaderInput '" + regin.type + "' cannot be applied";
			}
		}
	}
	
	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //
	
	/**
	 * 
	 * @return
	 */
	private function get_ambientColor():Vector3 { return this.shader.ambientColor; }
	
	private function set_ambientColor( value:Vector3 ):Vector3
	{
		return this.shader.ambientColor = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_diffuseColor():Vector3 { return this.shader.diffuseColor; }
	
	private function set_diffuseColor( value:Vector3 ):Vector3
	{
		return this.shader.diffuseColor = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_specularColor():Vector3 { return this.shader.specularColor; }
	
	private function set_specularColor( value:Vector3 ):Vector3
	{
		return this.shader.specularColor = value;
	}
	
	// ----------------------------------------------------------- //
	// ----------------------------------------------------------- //
	
	/**
	 * 
	 * @return
	 */
	private function get_specularWeight():Float { return this.shader.specularWeight; }
	
	private function set_specularWeight( value:Float ):Float
	{
		return this.shader.specularWeight = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_alpha():Float { return this.shader.alpha; }
	
	private function set_alpha( value:Float ):Float
	{
		return this.shader.alpha = value;
	}
	
	// ----------------------------------------------------------- //
	// ----------------------------------------------------------- //
	
	/**
	 * 
	 * @return
	 */
	private function get_ambientMap():Texture { return this.shader.ambient; }
	
	private function set_ambientMap( value:Texture ):Texture
	{
		this.shader.useTexture = true;
		return this.shader.ambient = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_diffuseMap():Texture { return this.shader.diffuse; }
	
	private function set_diffuseMap( value:Texture ):Texture
	{
		this.shader.useTexture = true;
		return this.shader.diffuse = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_normalMap():Texture { return this.shader.normal; }
	
	private function set_normalMap( value:Texture ):Texture
	{
		this.shader.useTexture = true;
		return this.shader.normal = value;
	}
}