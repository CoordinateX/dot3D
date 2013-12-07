package register;

import at.dotpoint.dot3d.model.register.container.RegisterList;

/**
 * ...
 * @author RK
 */
class RegisterListTest extends RegisterContainerT
{

	public function new() 
	{	
		super();
	}
	
	override private function setContainer( numEntries:Int ):Void
	{
		this.container = new RegisterList( numEntries );
	}
	
}