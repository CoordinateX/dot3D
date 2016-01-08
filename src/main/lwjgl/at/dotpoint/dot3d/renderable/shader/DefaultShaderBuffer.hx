package lwjgl.at.dotpoint.dot3d.renderable.shader;

import lwjgl.at.dotpoint.dot3d.renderable.buffer.ShaderBuffer;


/**
 * ...
 * @author RK
 */
class DefaultShaderBuffer extends ShaderBuffer
{

	//
	public function new()
	{
		super( new VertexShader(), new FragmentShader() );
	}

}

/**
 *
 */
private class VertexShader extends GLShader
{
	//
	public function new()
	{
		var source:String = "";
			source += "#version 330                                	\n";
			source += "uniform mat4 E_MODEL2WORLD_TRANSFORM;       	\n";
			source += "uniform mat4 W_WORLD2CAMERA_TRANSFORM;      	\n";
			source += "uniform vec3 W_LIGHT_DIRECTIONAL;   	      	\n";

			source += "in vec3 V_POSITION;                         	\n";
			source += "in vec3 V_NORMAL;                         	\n";

			source += "out float lpow;                         		\n";

			source += "void main(){                                																					\n";
			source += "    gl_Position = vec4(V_POSITION,1) * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;        							\n";
			source += "    lpow = max( dot( normalize(W_LIGHT_DIRECTIONAL), normalize(vec4(V_NORMAL,0) * E_MODEL2WORLD_TRANSFORM).xyz ), 0.0 ); 	\n";
			source += "}                                           																					\n";

		super( source, GLShaderType.VERTEX_SHADER );
	}

}

/**
 *
 */
private class FragmentShader extends GLShader
{
	//
	public function new()
	{
		var source:String = "";
			source += "#version 330									\n";
			source += "uniform vec4 M_COLOR;						\n";

			source += "in float lpow;								\n";

            source += "out vec3 out_color;							\n";

            source += "void main(){														\n";
        	source += "    out_color = M_COLOR.xyz * (lpow * 0.85 + 0.15);      		\n";
            source += "}																\n";

		super( source, GLShaderType.FRAGMENT_SHADER );
	}

}