package at.dotpoint.dot3d.shader;

import at.dotpoint.dot3d.model.material.ContextSettings;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.math.vector.Vector3;
import hxsl.Shader;
import flash.display3D.Context3DTriangleFace;

/**
 * ...
 * @author Gerald Hattensauer
 */
private class LShader extends Shader
{
	static var SRC = 
	{
		var thickness:Float;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		
		var input: 
		{
			pos:Float3,
			dir:Float3,
			sign:Float,
			color:Float3,
		};	
		
		var vcolor:Float3;
		
		// ------------------------------------------------------------------ //
		// ------------------------------------------------------------------ //
		// Vertex:
		
		function vertex( mpos:M44, mproj:M44, cam:Float3 ) 
		{
			var v = input.pos.xyzw * mpos;
			var p = input.dir.xyzw * mpos;
			
			// ----------- //
			
			var c = v.xyz - cam.xyz;		
			var d = v.xyz - p.xyz;
			
			var n = norm( cross( c.xyz, d ) );
			
			var k = [0, 0, 0, 0];
				k.xyz = n.xyz * input.sign * thickness * 0.1;
			
			// ----------- //	
			
			vcolor = input.color;			
			out = (v  +  k) * mproj;
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
 * 
 */
class LineShader extends Material
{
	private var cast_shader:LShader;
	
	public var thickness(get, set):Float;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new()
	{
		this.cast_shader = new LShader();		
		
		var settings:ContextSettings = new ContextSettings();
			settings.culling = Context3DTriangleFace.NONE;			
			
		super( this.cast_shader, settings );	
		
		this.thickness = 3;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 * 
	 * @return
	 */
	private function get_thickness():Float { return this.cast_shader.thickness; }
	
	private function set_thickness( value:Float ):Float
	{
		return this.cast_shader.thickness = value;
	}

}