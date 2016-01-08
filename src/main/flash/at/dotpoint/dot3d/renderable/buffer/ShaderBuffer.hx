package flash.at.dotpoint.dot3d.renderable.buffer;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.utils.Endian;
import haxe.at.dotpoint.display.renderable.input.IRenderInput;
import haxe.at.dotpoint.display.renderable.shader.buffer.AShaderBuffer;
import haxe.at.dotpoint.display.renderable.shader.data.IShaderData;
import haxe.io.BytesData;
import hxsl.Shader;

/**
 * ...
 * @author RK
 */
class ShaderBuffer<TShader:Shader> extends AShaderBuffer
{

	/**
	 *
	 */
	private var context:Context3D;

	/**
	 *
	 */
	private var shader:TShader;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( context:Context3D, shader:TShader )
	{
		super();

		this.context = context;
		this.shader = shader;
	}

	// ************************************************************************ //
	// Allocate
	// ************************************************************************ //

	/**
	 * data mesh to upload to the GPU
	 */
	override public function allocate( data:IShaderData ):Void
	{
		this.dispose( data );

		// ------------- //

		var instance:ShaderInstance = this.shader.getInstance(); 	// call only once before drawing!
			instance.varsChanged = true;

		this.setProgram( instance );
	}

	/**
	 * change the shader program of the context and build the program if necessary
	 * @param	shader
	 */
	private function setProgram( shader:ShaderInstance ):Void
	{
		if( shader.program == null )
		{
			shader.program = this.context.createProgram();

			var vdata:BytesData = shader.vertexBytes.getData();
				vdata.endian = Endian.LITTLE_ENDIAN;

			var fdata:BytesData = shader.fragmentBytes.getData();
				fdata.endian = Endian.LITTLE_ENDIAN;

			shader.program.upload( vdata, fdata );
		}

		this.context.setProgram( shader.program );
	}

	// ************************************************************************ //
	// Dispose
	// ************************************************************************ //

	/**
	 * remove the mesh data from the GPU
	 */
	override public function dispose( data:IShaderData ):Void
	{
		//;
	}

	// ************************************************************************ //
	// Bind
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as currently active on the GPU (shader calls will use this allocated mesh then)
	 */
	override public function bind( data:IShaderData, input:IRenderInput ):Void
	{
		this.context.setProgramConstantsFromVector( Context3DProgramType.VERTEX,   0, this.shader.getInstance().vertexVars.toData()   );
		this.context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, this.shader.getInstance().fragmentVars.toData() );

		this.setRegisterInputData( data, input );
	}

	/**
	 * sets the mesh buffer as inactive on the GPU (no mesh will be active for shader calls then)
	 */
	override public function unbind( data:IShaderData, input:IRenderInput ):Void
	{
		//;
	}

}