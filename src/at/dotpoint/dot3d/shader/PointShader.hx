package at.dotpoint.dot3d.shader;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.ShaderInput;
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
class PointShader extends Material<PShader>
{
	public var diffuseColor(get, set):Vector3;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new()
	{
		super( new PShader() );	
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	input
	 */
	public override function applyInput( shaderInput:ShaderInput ):Void 
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
	private function get_diffuseColor():Vector3 { return this.shader.diffuseColor; }
	
	private function set_diffuseColor( value:Vector3 ):Vector3
	{
		return this.shader.diffuseColor = value;
	}

}