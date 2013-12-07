package at.dotpoint.dot3d.model.register.error;

import at.dotpoint.core.event.Error;
import haxe.PosInfos;

/**
 * ...
 * @author RK
 */
class RegisterError extends Error
{

	public static var ID_BOUNDS:Int = 12;
	
	
	private function new( code:Int, name:String ) 
	{
		super( code, name );
	}
	
	/**
	 * 
	 * @param	?pos
	 * @return
	 */
	public static function createBoundsError( index:Int, max:Int, ?pos:PosInfos ):RegisterError
	{
		var error:RegisterError = new RegisterError( ID_BOUNDS, "RegisterError" );
			error.message = "given index " + index + " is out of bounds [0..." + max + "]";
			error.pos = pos;
			
		return error;
	}
}