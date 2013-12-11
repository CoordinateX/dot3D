package ;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

/**
 * ...
 * @author Gerald Hattensauer
 */
private class PShader extends Shader
{
	static var SRC = 
	{
		var diffuseColor:Float4;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		
		var input: 
		{
			pos:Float3,
		};	
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( mpos:M44, mproj:M44, light:Float3 ) 
		{
			/*var clip = input.pos.xyzw * mpos * mproj;			
			out = clip + mproj * input.pos;*/
			
			out = input.pos.xyzw * mpos * mproj;
		}
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Fragment:
		
		function fragment() 
		{
			out = diffuseColor;
		}
	};
}

/**
 * 
 */
class PointShader extends Material
{
	private var cast_shader:PShader;
	public var diffuseColor(get, set):Vector3;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new()
	{
		this.cast_shader = new PShader();			
		super( this.cast_shader );	
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 * 
	 * @return
	 */
	private function get_diffuseColor():Vector3 { return this.cast_shader.diffuseColor; }
	
	private function set_diffuseColor( value:Vector3 ):Vector3
	{
		return this.cast_shader.diffuseColor = value;
	}

}