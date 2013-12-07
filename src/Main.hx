package ;

import at.dotpoint.core.MainApplication;
import flash.Lib;
import mesh.MeshTableTest;
import register.RegisterListTest;
import register.RegisterTableTest;


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
		var registerListTest:RegisterListTest = new RegisterListTest();
			registerListTest.testInsert();
			
		var registerTableTest:RegisterTableTest = new RegisterTableTest();
			registerTableTest.testInsert();
			
		var meshTableTest:MeshTableTest = new MeshTableTest();
			meshTableTest.testVertex();
			meshTableTest.testVertex_viaIndex();
	}	
	

}