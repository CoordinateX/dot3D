package register;

import at.dotpoint.dot3d.model.register.container.RegisterTable;

/**
 * ...
 * @author RK
 */
class RegisterTableTest extends RegisterContainerT
{

	public function new() 
	{		
		super();
	}
	
	override private function setContainer( numEntries:Int ):Void
	{
		this.container = new RegisterTable( numEntries );
	}
	
}