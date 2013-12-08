package ;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

/**
 * ...
 * @author Gerald Hattensauer
 */
private class TShader extends Shader
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
			normal:Float3,
			uv:Float2,
		};	
		
		var tuv:Float2;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( mpos:M44, mproj:M44 /*light:Float3*/ ) 
		{
			out = input.pos.xyzw * mpos * mproj;
			
			//var tnorm = (input.norm * mpos).normalize();
			//lpow = light.dot(tnorm).max(0);
			
			tuv = input.uv;
		}
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:
		
		function fragment( ambient:Texture, diffuse:Texture, normal:Texture ) 
		{
			if ( useTexture )
			{
				out = diffuse.get(tuv); //(lpow * 0.8 + 0.2);
			}
			else
			{
				out = diffuseColor;
			}
		}
	};
}

/**
 * 
 */
class TestShader extends Material
{
	private var cast_shader:TShader;
	
	public var ambientColor(get,set):Vector3;
	public var diffuseColor(get, set):Vector3;	
	public var specularColor(get, set):Vector3;
	
	public var specularWeight(get,set):Float;
	public var alpha(get,set):Float;
	
	public var ambientMap(get,set):Texture;
	public var diffuseMap(get,set):Texture;
	public var normalMap(get,set):Texture;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new()
	{
		this.cast_shader = new TShader();	
		this.cast_shader.useTexture = false;
		
		super( this.cast_shader );	
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 * @return
	 */
	private function get_ambientColor():Vector3 { return this.cast_shader.ambientColor; }
	
	private function set_ambientColor( value:Vector3 ):Vector3
	{
		return this.cast_shader.ambientColor = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_diffuseColor():Vector3 { return this.cast_shader.diffuseColor; }
	
	private function set_diffuseColor( value:Vector3 ):Vector3
	{
		return this.cast_shader.diffuseColor = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_specularColor():Vector3 { return this.cast_shader.specularColor; }
	
	private function set_specularColor( value:Vector3 ):Vector3
	{
		return this.cast_shader.specularColor = value;
	}
	
	// ----------------------------------------------------------- //
	// ----------------------------------------------------------- //
	
	/**
	 * 
	 * @return
	 */
	private function get_specularWeight():Float { return this.cast_shader.specularWeight; }
	
	private function set_specularWeight( value:Float ):Float
	{
		return this.cast_shader.specularWeight = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_alpha():Float { return this.cast_shader.alpha; }
	
	private function set_alpha( value:Float ):Float
	{
		return this.cast_shader.alpha = value;
	}
	
	// ----------------------------------------------------------- //
	// ----------------------------------------------------------- //
	
	/**
	 * 
	 * @return
	 */
	private function get_ambientMap():Texture { return this.cast_shader.ambient; }
	
	private function set_ambientMap( value:Texture ):Texture
	{
		this.cast_shader.useTexture = true;
		return this.cast_shader.ambient = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_diffuseMap():Texture { return this.cast_shader.diffuse; }
	
	private function set_diffuseMap( value:Texture ):Texture
	{
		this.cast_shader.useTexture = true;
		return this.cast_shader.diffuse = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_normalMap():Texture { return this.cast_shader.normal; }
	
	private function set_normalMap( value:Texture ):Texture
	{
		this.cast_shader.useTexture = true;
		return this.cast_shader.normal = value;
	}
}