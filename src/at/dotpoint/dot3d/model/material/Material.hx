package at.dotpoint.dot3d.model.material;

import at.dotpoint.dot3d.model.register.RegisterType;
import hxsl.Data;
import hxsl.Shader;

/**
 * Encapsulates HXSL shader and provides some additional informations about the required inputs and supported
 * registers. also provides some helpful methodes to inspect and analyse the shader. also has an interface
 * to read and write shader values, but might be best to use Material and its registers for that.
 * 
 * @author Gerald Hattensauer
 */
@:access(hxsl.Shader)
//
class Material 
{

	/**
	 * 
	 */
	public var name:String;
	
	/**
	 * hxsl shader
	 */
	public var shader:Shader;	
	
	/**
	 * settings applied before rendering the material
	 */
	public var contextSetting:ContextSettings;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( shader:Shader, ?contextSetting:ContextSettings ) 
	{		
		this.shader = shader;
		this.contextSetting = contextSetting != null ? contextSetting : new ContextSettings();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public function getInstance():ShaderInstance
	{
		return this.shader.getInstance();
	}	
	
	// ************************************************************************ //
	// Shader Reflect
	// ************************************************************************ //		

	/**
	 * this.shader.globals.data VInput
	 */
  	public function reflectVertexBuffer():Array<RegisterType>
	{
		var global:ShaderGlobals = this.shader.globals;		
		var data:Data = global.data;
		
		var varlist:Array<Variable> = data.globals;
		var input:Variable = null;
		
		for ( v in varlist )
		{
			if ( v.kind == VInput )
			{
				input = v;
				break;
			}
		}
		
		var output:Array<RegisterType> = new Array<RegisterType>();
		var inputList:Array<{ name:String, t:VarType }> = Type.enumParameters( input.type )[0];
		
		for ( field in inputList )
		{
			output.push( new RegisterType( field.name, field.t ) );
		}
		
		return output;
	}
	
	/**
	 *  data.fragment.args
	 */
	public function reflectVertexArguments():Array<RegisterType>
	{		
		return this.toRegisterType( this.shader.globals.data.vertex.args );
	}
	
	/**
	 *  data.fragment.args
	 */
	public function reflectFragmentArguments():Array<RegisterType>
	{		
		return this.toRegisterType( this.shader.globals.data.fragment.args );
	}
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	private function toRegisterType( varlist:Array<Variable> ):Array<RegisterType>
	{
		var output:Array<RegisterType> = new Array<RegisterType>();
		
		for ( field in varlist )
		{
			output.push( new RegisterType( field.name, field.type ) );
		}
		
		return output;
	}
	
}