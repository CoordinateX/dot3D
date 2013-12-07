package at.dotpoint.dot3d.model.register.container;

import at.dotpoint.dot3d.model.register.error.RegisterError;
import at.dotpoint.dot3d.model.register.RegisterData;
import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.ds.Vector;
import haxe.PosInfos;

/**
 * ...
 * @author RK
 */
class RegisterList implements IRegisterContainer
{

	/**
	 * position, color, uv, ...
	 */
	public var registerTypes:Array<RegisterType>;
	
	/**
	 * v1:	position, color, uv, ...
	 * v2:	position, color, uv, ...
	 * vn:	position, color, uv, ...
	 */
	private var entries(default, null):Vector< Array<RegisterData> >;	
	
	/**
	 * number of entries data can be get from and set to
	 */
	public var numEntries(default, null):Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( numEntries:Int ) 
	{
		this.numEntries = numEntries;
		
		this.entries = new Vector< Array<RegisterData> >( this.numEntries );
		this.registerTypes = new Array<RegisterType>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * searches for the given attribute and returns it's data when found, or null
	 * the data can usually be interpreted as Vector2 or Vector3
	 */
	public function getData( type:RegisterType, index:Int, ?output:Array<Float> ):Array<Float>
	{
		if( this.hasRegisterType( type ) )
		{
			var entry:Array<RegisterData> = this.getEntry( index );
			
			if( entry != null ) 
				return this.getRegisterData( entry, type ).getValues( 0, output );
		}
		
		return null;
	}
	
	/**
	 * adds the given values to the RegisterData of the given index
	 */
	public function setData( type:RegisterType, index:Int, values:Array<Float> ):Void
	{
		var entry:Array<RegisterData> = this.getEntry( index, true );
		var data:RegisterData = this.getRegisterData( entry, type );
		
		if ( data == null )
		{
			this.addRegisterData( type );
			data = this.getRegisterData( entry, type );
		}
		
		data.setValues( values, 0 );
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// DataTypes:
	
	/**
	 * 
	 */
	public function getRegisterTypes():Array<RegisterType>
	{	
		return this.registerTypes.copy();
	}
	
	/**
	 * 
	 */
	public function hasRegisterType( type:RegisterType ):Bool
	{
		for( regType in this.registerTypes )
		{
			if( regType == type )
				return true;
		}
		
		return false;
	}
	
	// ************************************************************************ //
	// Stream
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function getEntry( index:Int, create:Bool = false ):Array<RegisterData>
	{
		this.checkBounds( index );
		
		var entry:Array<RegisterData> = this.entries.get( index );
		
		if( create && entry == null )
		{
			entry = new Array<RegisterData>();		
			
			for( type in this.registerTypes )
			{
				entry.push( new RegisterData( type, 1 ) );
				entry.sort( this.sortStream );			
			}
			
			this.entries[index] = entry;
		}
		
		return entry;
	}
	
	/**
	 * 
	 */
	private function getRegisterData( entry:Array<RegisterData>, type:RegisterType ):RegisterData
	{
		for( register in entry )
		{
			if( register.type == type )
				return register;
		}		
		
		return null;
	}
	
	/**
	 * 
	 */
	private function addRegisterData( type:RegisterType ):Void
	{
		if ( this.hasRegisterType( type ) ) 
			throw "DataType " + type + " already exists";
		
		this.registerTypes.push( type );	
		
		// ------------- //			
		
		for( i in 0...this.numEntries )
		{
			var entry:Array<RegisterData> = this.entries[i];
			
			if( entry != null )
			{
				entry.push( new RegisterData( type, 1 ) );
				entry.sort( this.sortStream );	
			}	
		}
	}	
	
	/**
	 * removes an DataStream and returns true in case it worked
	 */
	private function removeRegisterData( stream:RegisterData ):Bool
	{
		return false;
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
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// Error-Checks
	
	// out of bounds check
	inline private function checkBounds( index:Int, ?pos:PosInfos ):Void
	{
		if ( index < 0 || index >= this.numEntries) 
			throw RegisterError.createBoundsError( index, this.numEntries, pos );
	}
	
}