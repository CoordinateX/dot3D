package at.dotpoint.dot3d.render.shader;

import at.dotpoint.display.register.RegisterContext;
import at.dotpoint.display.register.RegisterFormat;
import at.dotpoint.display.register.RegisterHelper;
import at.dotpoint.display.register.RegisterType;
import at.dotpoint.display.rendering.shader.IShader;
import at.dotpoint.display.rendering.shader.ShaderSignature;
import hxsl.Data;
import hxsl.Data.Variable;
import hxsl.Data.VarType;
import hxsl.Shader;
import hxsl.Shader.ShaderInstance;

/**
 * ...
 * @author RK
 */
@:access(hxsl.Shader)
//
class Stage3DShader implements IShader
{
	
	/**
	 * settings applied before rendering the material
	 */
	public var contextSetting:Stage3DShaderContext;	
	
	/**
	 * 
	 */
	private var signature:ShaderSignature;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		
	}
	
	// ************************************************************************ //
	// IShader
	// ************************************************************************ //
	
	/**
	 * 
	 * @return
	 */
	public function getShaderSignature():ShaderSignature 
	{
		return this.signature;
	}
	
	/**
	 * 
	 * @param	type
	 * @param	data
	 */
	public function setRegisterData( type:RegisterType, data:Dynamic ):Void 
	{
		return;
	}

	// ************************************************************************ //
	// Stage3D
	// ************************************************************************ //
	
	/**
	 * 
	 * @return
	 */
	public function getInternalShader():Shader
	{
		return null;
	}
	
	/**
	 * 
	 * @return
	 */
	public function getShaderInstance():ShaderInstance
	{
		return this.getInternalShader().getInstance();
	}	
	
	// ************************************************************************ //
	// Shader Reflect
	// ************************************************************************ //		

	/**
	 * 
	 */
	private function generateShaderSignature( shaderID:String ):ShaderSignature 
	{
		var registers:Array<RegisterType> = this.generateShaderRegisterList();		
		var signature:ShaderSignature = new ShaderSignature( shaderID, registers.length );
		
		for( type in registers )
		{
			if( type != null )
				signature.addRegisterType( type );
		}
		
		return signature;
	}
	
	/**
	 * 
	 * @return
	 */
	private function generateShaderRegisterList():Array<RegisterType>
	{
		var output:Array<RegisterType> = new Array<RegisterType>();
		
		this.reflectVertexBuffer( output );
		this.reflectVertexArguments( output );
		this.reflectFragmentArguments( output );
		
		return output;
	}
	
	// ---------------------------------------------- //
	// ---------------------------------------------- //
	
	/**
	 * this.shader.globals.data VInput
	 */
  	private function reflectVertexBuffer( output:Array<RegisterType>):Array<RegisterType>
	{
		var global:ShaderGlobals = this.getInternalShader().globals;		
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
		
		// -------------- //
		
		var inputList:Array<{ name:String, t:VarType }> = Type.enumParameters( input.type )[0];
		
		for ( field in inputList )
		{
			output.push( RegisterHelper.getTypeByID( field.name ) );
		}
		
		return output;
	}
	
	/**
	 *  data.vertex.args
	 */
	private function reflectVertexArguments( output:Array<RegisterType>):Array<RegisterType>
	{		
		return this.toRegisterType( output, this.getInternalShader().globals.data.vertex.args );
	}
	
	/**
	 *  data.fragment.args
	 */
	private function reflectFragmentArguments( output:Array<RegisterType> ):Array<RegisterType>
	{		
		return this.toRegisterType( output, this.getInternalShader().globals.data.fragment.args );
	}
	
	// ---------------------------------------------- //
	// ---------------------------------------------- //
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	private function toRegisterType( output:Array<RegisterType>, varlist:Array<Variable> ):Array<RegisterType>
	{
		for ( field in varlist )
		{
			output.push( RegisterHelper.getTypeByID( field.name ) );
		}
		
		return output;
	}
	
	/**
	 * 
	 * @param	varType
	 * @return
	 */
	private function toRegisterFormat( varType:VarType ):RegisterFormat
	{
		switch( varType )
		{
			case VarType.TBool:		return RegisterFormat.TBOOL;
			case VarType.TInt:		return RegisterFormat.TINT;
			case VarType.TNull:		return RegisterFormat.TNULL;
			case VarType.TFloat:	return RegisterFormat.TFLOAT_1;
			case VarType.TFloat2:	return RegisterFormat.TFLOAT_2;
			case VarType.TFloat3:	return RegisterFormat.TFLOAT_3;
			case VarType.TFloat4:	return RegisterFormat.TFLOAT_4;
			case VarType.TMatrix:	return RegisterFormat.TMATRIX_44;
			
			default:
				throw "Shader VarType not supported: " + varType;
		}
		
		return null;
	}
}