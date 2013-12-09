package at.dotpoint.dot3d.model.register;

import at.dotpoint.dot3d.model.register.RegisterData;
import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.ds.Vector;
import haxe.PosInfos;

/**
 * ...
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
	 * list with RegisterTypes
	 */
	private var signature(default, null):RegisterSignature;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( signature:RegisterSignature ) 
	{
		this.signature = signature;		
		this.registers = new Vector<RegisterData<T>>( this.signature.size() );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * searches for the given attribute and returns it's data when found, or null
	 * the data can usually be interpreted as Vector2 or Vector3
	 */
	public function getData( type:RegisterType, index:Int, ?output:Array<T> ):Array<T>
	{
		var stream:RegisterData<T> = this.getRegisterData( type );
		
		if ( stream != null )	return stream.getValues( index, output );
		else					return null;
	}
	
	/**
	 * adds the given values to the RegisterData of the given index
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
	 */
	public function getRegisterData( type:RegisterType ):RegisterData<T>
	{
		var index:Int = this.signature.indexOf( type );	
		
		if ( index < 0 ) 	return null;
		else 				return this.registers[ index ];	
	}
	
	/**
	 * adds the DataStream to the register stream. throws errors in case it 
	 * does exist already or the given stream has not the right size for the amount of registers
	 */
	public function setRegisterData( stream:RegisterData<T> ):Void
	{
		var index:Int = this.signature.indexOf( stream.type );	
		
		if ( index < 0 ) 
			throw "RegisterData for type: " + stream.type + " is not allowed in this RegisterContainer";
		
		this.registers[ index ] = stream;
	}	
	
}