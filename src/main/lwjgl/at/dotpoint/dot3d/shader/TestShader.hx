package lwjgl.at.dotpoint.dot3d.shader;

import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.math.vector.Matrix44;
import haxe.at.dotpoint.math.vector.Vector3;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShader;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShaderProgram;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShaderType;
import org.lwjgl.opengl.GL20;

/**
 * ...
 * @author RK
 */
class TestShader extends Java3DShaderProgram
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		var vertex_program:String = "";
			vertex_program += "#version 330                                	\n";
			vertex_program += "uniform mat4 E_MODEL2WORLD_TRANSFORM;       	\n";
			vertex_program += "uniform mat4 W_WORLD2CAMERA_TRANSFORM;      	\n";
			vertex_program += "uniform vec3 W_LIGHT_DIRECTIONAL;   	      	\n";

			vertex_program += "in vec3 V_POSITION;                         	\n";
			vertex_program += "in vec2 V_UV_COORDINATES;                   	\n";
			vertex_program += "in vec3 V_NORMAL;                         	\n";

		//	vertex_program += "out vec2 tuv;                         		\n";
			vertex_program += "out float lpow;                         		\n";

			vertex_program += "void main(){                                															\n";
			vertex_program += "    gl_Position= vec4(V_POSITION,1) * E_MODEL2WORLD_TRANSFORM * W_WORLD2CAMERA_TRANSFORM;        			\n";
		//	vertex_program += "    vec4 a= vec4(1,1,1,1) * E_MODEL2WORLD_TRANSFORM;        			\n";
		//	vertex_program += "    gl_Position= vec4(V_POSITION,1) + a;        			\n";
			vertex_program += "    lpow = max( dot( normalize(W_LIGHT_DIRECTIONAL), normalize(vec4(V_NORMAL,0) * E_MODEL2WORLD_TRANSFORM).xyz ), 0.0 ); 	\n";
		//	vertex_program += "    tuv = V_UV_COORDINATES;        																	\n";
			vertex_program += "}                                           															\n";

		var fragment_program:String = "";
			fragment_program += "#version 330                               \n";
			fragment_program += "uniform vec4 M_COLOR;                       \n";

		//	fragment_program += "in vec2 tuv;                              	\n";
			fragment_program += "in float lpow;                              \n";

            fragment_program += "out vec3 out_color;                        \n";

            fragment_program += "void main(){                               					\n";
            fragment_program += "    out_color= M_COLOR.xyz * (lpow * 0.95 + 0.05);      				\n";
         //   fragment_program += "    out_color= M_COLOR.xyz;      				\n";
         //  fragment_program += "    out_color=vec3(0.8,0.2,0.1);      				\n";
            fragment_program += "}                                          					\n";

		var vshader:Java3DShader = new Java3DShader( vertex_program, Java3DShaderType.VERTEX_SHADER );
		var fshader:Java3DShader = new Java3DShader( fragment_program, Java3DShaderType.FRAGMENT_SHADER );

		super( vshader, fshader );

		this.signature = new ShaderSignature( "TestShader", 7 );
		this.signature.addRegisterType( RegisterHelper.V_POSITION );
		this.signature.addRegisterType( RegisterHelper.V_UV_COORDINATES );
		this.signature.addRegisterType( RegisterHelper.V_NORMAL );
		this.signature.addRegisterType( RegisterHelper.M_COLOR );
		this.signature.addRegisterType( RegisterHelper.E_MODEL2WORLD_TRANSFORM );
		this.signature.addRegisterType( RegisterHelper.W_WORLD2CAMERA_TRANSFORM );
		this.signature.addRegisterType( RegisterHelper.W_LIGHT_DIRECTIONAL );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	type
	 * @param	data
	 */
	override public function setRegisterData( type:RegisterType, data:Dynamic ):Void
	{
		if( type.ID == RegisterHelper.E_MODEL2WORLD_TRANSFORM.ID )
			this.setUniformValue( type, cast( data, Matrix44 ).getArray() );

		if( type.ID == RegisterHelper.W_WORLD2CAMERA_TRANSFORM.ID )
			this.setUniformValue( type, cast( data, Matrix44 ).getArray());

		if( type.ID == RegisterHelper.W_LIGHT_DIRECTIONAL.ID )
			this.setUniformValue( type, cast( data, Vector3 ).toArray( false ) );

		if( type.ID == RegisterHelper.M_COLOR.ID )
			this.setUniformValue( type, cast( data, Vector3 ).toArray( true ) );
	}
}