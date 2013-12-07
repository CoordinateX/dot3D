package register;

import at.dotpoint.dot3d.model.register.container.IRegisterContainer;
import at.dotpoint.dot3d.model.register.container.RegisterList;
import at.dotpoint.dot3d.model.register.container.RegisterTable;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.error.RegisterError;
import massive.munit.Assert;

/**
 * ...
 * @author RK
 */

class RegisterContainerT
{

	private var container:IRegisterContainer;	
	
	inline static function pos_1():Array<Float> { return [0.1, 0.2, 0.3]; }
	inline static function pos_2():Array<Float> { return [1.1, 1.2, 1.3]; }
	inline static function pos_3():Array<Float> { return [2.1, 2.2, 2.3]; }
	
	// ************************************************************************ //
	// ************************************************************************ //
	
	public function new(){			
	}
	
	private function setContainer( numEntries:Int ):Void
	{
		throw "override";
	}
	
	// ************************************************************************ //
	// ************************************************************************ //
	
	/**
	 * 
	 */
	@Test
	public function testInsert():Void
	{
		this.setContainer( 2 );
		
		this.setValue( Register.VERTEX_POSITION, pos_1(), 0 ); 
		this.setValue( Register.VERTEX_POSITION, pos_2(), 1 );
		
		try
		{
			this.setValue( Register.VERTEX_POSITION, pos_3(), 2 ); 
		}
		catch( error:RegisterError )
		{
			Assert.areEqual( RegisterError.ID_BOUNDS, error.code );
		}	
	}
	
	/**
	 * 
	 */
	private function setValue( type:RegisterType, value:Array<Float>, index:Int ):Void
	{
		this.container.setData( type, index, value );
		
		var result:Array<Float> = this.container.getData( type, index );
		
		trace( "insert-result: " + result );
		
		Assert.isNotNull( value );
		Assert.areEqual( value[0], result[0] );
		Assert.areEqual( value[1], result[1] );
		Assert.areEqual( value[2], result[2] );
	}
}