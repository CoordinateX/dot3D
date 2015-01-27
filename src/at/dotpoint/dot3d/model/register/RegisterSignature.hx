package at.dotpoint.dot3d.model.register;

import at.dotpoint.core.datastructure.VectorUtil;
import at.dotpoint.core.datastructure.VectorSet;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.math.Limit;

using at.dotpoint.core.datastructure.VectorUtil;

/**
 * Lists the allowed RegisterTypes that can be stored in a RegisterContainer. Also saves 
 * the amount of entries that are expected for each type. Those informations are used to
 * allocate the right amount of space and initialisations. RegisterContainer also uses
 * the signature to map and lookup its data to the allowed RegisterTypes.
 * 
 * @author RK
 */
@:access( at.dotpoint.core.datastructure.VectorSet )
//
class RegisterSignature
{	
	
	/**
	 * internal list, does make sure its values are unique
	 */
	private var registers:VectorSet<RegisterDataSignature>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	public function new( numRegisters:Int ) 
	{
		if( numRegisters <= 0 )
			throw "numRegisters must be >= 1";

		this.registers = new VectorSet<RegisterDataSignature>( numRegisters );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * amount of different RegisterTypes
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
	 * adds the given type in case it hasn't been stored already and also saves
	 * the expected amount of entries used to allocate the correct amount of memory
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
	 * how many entries are expected to be stored for the given RegisterType
	 * 
	 * @param	type
	 * @return -1 in case the given type is invalid, 0 default
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
	 * reverse function of indexOf() so you can get the RegisterType
	 * in case you know its index where it is saved. used for quick lookup
	 * without any searches. 
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
	 * calculates the total number of float/int entries all RegisterTypes of the signature 
	 * would take up for a single vertex for example. is in fact a simple loop through the 
	 * types and add the size together.
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
	 * searches for the givne RegisterType and returns the index position at which 
	 * it is internally stored. this index can (and is) be used to quickly map and
	 * lookup register types. e.g.: register container uses the same order for its
	 * data and uses the signature to map and lookup RegisterTypes
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
 * Helper Container and actual internal representation
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