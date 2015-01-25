package at.dotpoint.dot3d.model.material;

import haxe.ds.Vector;
import hxsl.Shader;

/**
 * 
 * @author RK
 */
class ShaderInput
{
	
	/**
	 * 
	 */
	public var values:Vector<RegisterInput>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( size:Int ) 
	{		
		this.values = new Vector<RegisterInput>( size );
		
		for( i in 0...size )
			this.values[i] = new RegisterInput( null );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	index
	 * @param	input
	 */
	public function setValue( type:String, input:Dynamic ):Void
	{
		var index:Int = this.indexOf( type );
		
		if( index == -1 )
			throw "cannot set shaderInput '" + type + "'";
		
		var regin:RegisterInput = this.values[index];	
			regin.type = type;
			regin.input = input;	
	}
	
	/**
	 * 
	 * @param	type
	 * @return
	 */
	public function indexOf( type:String ):Int
	{
		for( i in 0...this.values.length )
		{
			if( this.values[i].type == type || this.values[i].type == null )
				return i;
		}
		
		return -1;
	}
	
}

class RegisterInput
{
	public var type:String;
	public var input:Dynamic;
	
	public function new( type:String )
	{
		this.type = type;
	}
}