package ;

import at.dotpoint.core.MainApplication;
import flash.Lib;

/**
 * ...
 * @author RK
 */
class Main extends MainApplication
{
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	static public function main() 
	{		
		Lib.current.addChild( new Main() );
	}	
	
	public function new() 
	{
		super();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	override private function init():Void
	{
		
	}	
	

}