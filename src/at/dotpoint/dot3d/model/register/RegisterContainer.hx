package at.dotpoint.dot3d.model.register;

import at.dotpoint.dot3d.model.register.error.RegisterError;
import at.dotpoint.dot3d.model.register.RegisterData;
import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.PosInfos;

/**
 * ...
 * 
 * @author RK
 */
@:access( at.dotpoint.dot3d.model.register )
//
class RegisterContainer
{

	/**
	 * position:	v1x, v1y, v1z, 	v2x, v2y, v2z, 	...,	vnx, vny, vnz
	 * color:		v1r, v1g, v1b, 	v2r, v2g, v2b, 	...,	vnr, vng, vnb
	 * uv:			v1u, v1v, 		v2u, v2v, 		...,	vnu, vnv
	 */
	private var registers(default, null):Array<RegisterData>;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		this.registers = new Array<RegisterData>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	public function getNumEntries():Int
	{
		var max:Int = 0;
		
		for( register in this.registers )
		{
			if( register.numEntries > max )
				max = register.numEntries;
		}
		
		return max;
	}
	
	/**
	 * 
	 * @return
	 */
	public function getNumTypes():Int
	{
		return this.registers.length;
	}
	
	// ************************************************************************ //
	// get/set
	// ************************************************************************ //	
	
	/**
	 * searches for the given attribute and returns it's data when found, or null
	 * the data can usually be interpreted as Vector2 or Vector3
	 */
	public function getData( type:RegisterType, index:Int, ?output:Array<Float> ):Array<Float>
	{
		var stream:RegisterData = this.getRegisterData( type );
		
		if ( stream != null )	return stream.getValues( index, output );
		else					return null;
	}
	
	/**
	 * adds the given values to the RegisterData of the given index
	 */
	public function setData( type:RegisterType, index:Int, values:Array<Float> ):Void
	{
		var stream:RegisterData = this.getRegisterData( type );
		
		if ( stream == null )
			throw "must add a RegisterData Object first";
		
		stream.setValues( values, index );
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// DataTypes:
	
	/**
	 * creates a list of all existing RegisterType saved for this mesh therefore
	 * lists all register-attribute-types that are avaible
	 */
	public function getRegisterTypes():Array<RegisterType>
	{	
		var list:Array<RegisterType> = new Array<RegisterType>();
		
		for ( stream in this.registers )
		{
			list.push( stream.type );
		}
		
		return list;
	}
	
	/**
	 * checks if the given RegisterType exists already in form of a RegisterData
	 */
	public function hasRegisterType( type:RegisterType ):Bool
	{
		return this.getRegisterData( type ) != null;
	}
	
	// ************************************************************************ //
	// Stream
	// ************************************************************************ //	
	
	/**
	 * searches for the given RegisterType and returns the corresponding RegisterData in case it exists or null
	 */
	public function getRegisterData( type:RegisterType ):RegisterData
	{
		for ( stream in this.registers )
		{
			if ( stream.type.ID == type.ID )
				return stream;
		}
		
		return null;
	}
	
	/**
	 * adds the DataStream to the register stream. throws errors in case it 
	 * does exist already or the given stream has not the right size for the amount of registers
	 */
	public function addRegisterData( stream:RegisterData ):Void
	{
		if ( this.hasRegisterType( stream.type ) ) 
			throw "DataType " + stream.type + " already exists";
		
		// ------------- //			
		
		this.registers.push( stream );
		this.registers.sort( this.sortStream );
	}	
	
	/**
	 * removes an DataStream and returns true in case it worked
	 */
	public function removeRegisterData( stream:RegisterData ):Bool
	{
		#if debug
		if ( !this.hasRegisterType( stream.type ) ) 
			trace( "DataStream " + stream.type + " does not exist" );
		#end	
		
		return this.registers.remove( stream );
	}	
	
	/**
	 * 
	 * @param	stream1
	 * @param	stream2
	 * @return
	 */
	private function sortStream( stream1:RegisterData, stream2:RegisterData ):Int
	{
		return stream1.type.priority - stream2.type.priority;
	}
	
}