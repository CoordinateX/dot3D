package at.dotpoint.dot3d.model.material;

import haxe.ds.StringMap;
import hxsl.Shader;

/**
 * 
 * @author RK
 */
class ShaderInput extends StringMap<Dynamic>
{


	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		super();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	shader
	 */
	public function apply( shader:Shader ):Void
	{
		var iter:Iterator<String> = this.keys();
		
		while( iter.hasNext() )
		{
			var type:String = iter.next();			
			Reflect.setProperty( shader, type, this.get( type ) );
		}
	}
}