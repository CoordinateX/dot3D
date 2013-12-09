package at.dotpoint.dot3d.model.register;

import at.dotpoint.core.ds.VectorUtil;
import at.dotpoint.core.ds.VectorSet;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.math.Limit;

using at.dotpoint.core.ds.VectorUtil;

/**
 * ...
 * @author RK
 */
@:access( at.dotpoint.core.ds.VectorSet )
//
class RegisterSignature
{	
	
	/**
	 * 
	 */
	private var registers:VectorSet<RegisterDataSignature>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( numRegisters:Int ) 
	{
		this.registers = new VectorSet<RegisterDataSignature>( numRegisters );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	public function size():Int
	{
		return this.registers.numEntries;
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //
	
	/**
	 * 
	 * @param	type
	 * @return
	 */
	public function hasType( type:RegisterType ):Bool
	{		
		return this.indexOf( type ) != -1;
	}	
	
	/**
	 * 
	 * @param	type
	 * @return
	 */
	public function addType( type:RegisterType, numEntries:Int ):Bool
	{
		if( this.hasType( type ) )
			return false;		
		
		this.registers.add( new RegisterDataSignature( type, numEntries ) );	
		this.registers.list.sort( this.sort );
		
		return true;
	}
	
	/**
	 * 
	 * @param	type
	 */
	public function removeType( type:RegisterType ):Bool
	{
		var index:Int = this.indexOf( type );
		
		if( index == -1 )
			return false;
		
		// ------ //	
		
		return this.registers.remove( this.registers.list[ index ] );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //	
	
	/**
	 * 
	 * @param	type
	 * @return
	 */
	public function getNumEntries( type:RegisterType ):Int
	{
		var index:Int = this.indexOf( type );
		
		if( index == -1 )
			return -1;
		
		// ------ //	
		
		return this.registers.list[ index ].numEntries;
	}
	
	/**
	 * 
	 * @param	index
	 * @return
	 */
	public function getTypeByIndex( index:Int ):RegisterType
	{
		if( index >= 0 && index < this.size() )
		{
			return this.registers.list[index].type;
		}
		
		return null;
	}
	
	/**
	 * 
	 * @return
	 */
	public function getTotalRegisterSize():Int
	{
		var total:Int = 0;
		
		for( j in 0...this.size() )
		{
			total += this.getTypeByIndex(j).size;
		}
		
		return total;
	}
	
	/**
	 * 
	 * @param	type
	 * @return
	 */
	public function indexOf( obj:RegisterType ):Int
	{
		for( i in 0...this.size() )
		{
			if( this.registers.list[i].type.ID == obj.ID )
				return i;
		}
		
		return -1;
	}
	
	/**
	 * 
	 */
	public function toArray():Array<RegisterType>
	{
		var array:Array<RegisterType> = new Array<RegisterType>();
		
		for( j in 0...this.size() )
		{
			array.push( this.registers.list[j].type );
		}
		
		return array;
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //	
	
	/**
	 * x > y pos int
	 * 
	 * @param	stream1
	 * @param	stream2
	 * @return
	 */
	private function sort( t1:RegisterDataSignature, t2:RegisterDataSignature ):Int
	{
		if( t1 == null )
			return Limit.INT32_MAX;
		
		if( t2 == null )
			return Limit.INT32_MIN;	
			
		return t1.type.priority - t2.type.priority;
	}
}
 
/**
 * Helper Container
 */
private class RegisterDataSignature
{
	public var type(default,null):RegisterType;
	public var numEntries(default,null):Int;
	
	public function new( type:RegisterType, numEntries:Int )
	{
		this.type = type;
		this.numEntries = numEntries;
	}
}