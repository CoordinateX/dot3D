package at.dotpoint.dot3d.model.register;

import at.dotpoint.dot3d.model.register.RegisterData;
import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.ds.Vector;

/**
 * Stores Float/Int data for each type of data in a seperate flat list and is mostly used to store vertex data
 * but can also be used within materials or other types of mesh related data. Types are destinguished via
 * RegisterTypes which in turn are defined globaly. Data internally is stored via RegisterData.
 * 
 * @author RK
 */
class RegisterContainer<T:Dynamic> 
{

	/**
	 * position:	v1x, v1y, v1z, 	v2x, v2y, v2z, 	...,	vnx, vny, vnz
	 * color:		v1r, v1g, v1b, 	v2r, v2g, v2b, 	...,	vnr, vng, vnb
	 * uv:			v1u, v1v, 		v2u, v2v, 		...,	vnu, vnv
	 */
	private var registers(default, null):Vector<RegisterData<T>>;	
	
	/**
	 * list with RegisterTypes used to allocate the required space and 
	 * direct to the correct data when writing/reading data of a certain type
	 */
	private var signature(default, null):RegisterSignature;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	signature list of used RegisterTypes
	 */
	public function new( signature:RegisterSignature ) 
	{
		this.signature = signature;		
		this.registers = new Vector<RegisterData<T>>( this.signature.size() );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * looks up the RegisterData object storing the requested data using the provided type.
	 * accesses the data using the given pointer and returns the data-tuple. its size
	 * is depending on the RegisterType. e.g.: position has 3 values, accessing the first
	 * position data you have to use 0 as index, the second position 1, etc. so no need to 
	 * compensate for the way it is stored internally
	 * 
	 * @param	type type (ID) of which RegisterData you want the data from
	 * @param	index offset pointing to data just like in an array
	 * @param	?output optional container to store the data in; overrides any data in it, does not clear it first
	 * @return	output Array if used or a new one; size depends on the data you accessed
	 */
	public function getData( type:RegisterType, index:Int, ?output:Array<T> ):Array<T>
	{
		var stream:RegisterData<T> = this.getRegisterData( type );
		
		if ( stream != null )	return stream.getValues( index, output );
		else					return null;
	}
	
	/**
	 * adds or overrides the given values to the RegisterData of the given type at the given index.
	 * creates an RegisterData object internally if none exists using the signature of this container.
	 * e.g.: position has 3 values, setting the first position data you have to use 0 as index, 
	 * the second position 1, etc. so no need to compensate for the way it is stored internally
	 * 
	 * @param	type type (ID) of which RegisterData you want the data from
	 * @param	index offset pointing to data just like in an array
	 * @param	values tuple you want to store; make sure it has the exact size of the type you store
	 */
	public function setData( type:RegisterType, index:Int, values:Array<T> ):Void
	{
		var stream:RegisterData<T> = this.getRegisterData( type );
		
		if ( stream == null && this.signature.hasType( type ) )
		{
			stream = new RegisterData<T>( type, this.signature.getNumEntries( type ) );
			this.setRegisterData( stream );
		}
		
		stream.setValues( values, index );
	}
	
	// ------------------------------------------------------------------ //
	// ------------------------------------------------------------------ //

	/**
	 * checks if the given RegisterType exists already in form of a RegisterData
	 */
	public function hasRegisterData( type:RegisterType ):Bool
	{
		return this.getRegisterData( type ) != null;
	}
	
	/**
	 * searches for the given RegisterType and returns the corresponding RegisterData in case it exists or null
	 * this methodes uses the signature to lookup the position the RegisterData should be stored into, changing
	 * signature might affect this methode dramatically.
	 */
	public function getRegisterData( type:RegisterType ):RegisterData<T>
	{
		var index:Int = this.signature.indexOf( type );	
		
		if ( index < 0 ) 	return null;
		else 				return this.registers[ index ];	
	}
	
	/**
	 * adds/overwrites the given RegisterData in case the signature allows the type. make sure the size of the
	 * given data is sufficent to our purpose as it does not check the signature.
	 */
	public function setRegisterData( stream:RegisterData<T> ):Void
	{
		var index:Int = this.signature.indexOf( stream.type );			
		
		if ( index < 0 ) 
			throw "RegisterData for type: " + stream.type + " is not allowed in this RegisterContainer";
			
		this.registers[ index ] = stream;
	}	
	
}