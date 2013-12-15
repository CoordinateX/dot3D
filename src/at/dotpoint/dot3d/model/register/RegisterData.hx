package at.dotpoint.dot3d.model.register;

import haxe.ds.Vector;

/**
 * Stores specific data like UV coordinates, normals, transformations, etc of vertices and shader; 
 * The data is stored continously as float/int values in an array. Complex Data like a Matrix, Array
 * or Object must be flattend into a single float/int array.
 * <br/><br/>
 * type:	position
 * stream:	v1x, v1y, v1z, 	v2x, v2y, v2z, 	...
 */
class RegisterData<T:Dynamic> 
{

	/**
	 * what type of data is stored?
	 */
	public var type(default, null):RegisterType;	
	
	/**
	 * values as a flat float list - might be for more vertices/entries
	 */
	private var stream:Vector<T>;
	
	/**
	 * used to alloate the required space and bounding check
	 */
	public var numEntries(default,null):Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( type:RegisterType, numEntries:Int = 1 ) 
	{
		this.type = type;			
		this.numEntries = numEntries;
		
		this.stream = new Vector<T>( this.numEntries * this.type.size );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * creates and fills a vector with the attribute data of the vertex with the given index
	 */
	public function getValues( vindex:Int = 0, ?output:Array<T> ):Array<T>
	{
		vindex = vindex * this.type.size;	
		
		var size:Int = this.type.size;		
		
		if( output == null )
			output = new Array<T>(); 
		
		for ( i in 0...size )
		{
			this.checkBounds( vindex + i );
			output[i] = this.stream[ vindex + i ];
		}
		
		return output;
	}
	
	/**
	 * overwrites the attribute data of the vertex with the given index with the data provided in the argument
	 */
	public function setValues( values:Array<T>, vindex:Int = 0 ):Void
	{
		vindex = vindex * this.type.size;		
		
		this.checkAttributeLength( values.length );
		
		for ( i in 0...this.type.size )
		{
			this.checkBounds( vindex + i );
			this.stream[ vindex + i ] = values[i];
		}
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// Error-Checks
	
	// attribute length check
	inline private function checkAttributeLength( size:Int ):Void
	{
		if ( size != this.type.size ) 
			throw "must set exactly " + this.type.size + " values for the AttributeType " + this.type.ID;
	}
	
	// out of bounds check
	inline private function checkBounds( index:Int ):Void
	{
		if ( index < 0 || index > this.stream.length ) 
			throw "given index " + index + " is out of bounds (max: " + this.stream.length + ")";
	}
	
	
}