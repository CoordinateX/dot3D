package at.dotpoint.dot3d.model.register;

import flash.display3D.Context3DVertexBufferFormat;
import hxsl.Data;

/**
 * used to uniquely identify RegisterData, specify the size a single entry consumes (amount of floats/ints/bytes)
 * and in which order they should be stored (importend for shaders). Use the Register class to store new RegisterTypes
 * and reference them instead of creating new Types all over again. Types might be referenced and compared directly
 * without using ID. Make sure each RegisterType is unique ...
 * 
 * @author Gerald Hattensauer
 */
class RegisterType
{

	/**
	 * ID: unique within material or vertexdata of a mesh
	 */
	public var ID(default,null):String;
	
	/**
	 * size it will take to store the data is derived from it
	 */
	public var format:VarType;
	
	/**
	 * amount of individual components the data is composed of. e.g. position: 3
	 */
	public var size(get, null):Int;
	
	/**
	 * relative position in mesh vertex buffer and shader
	 */
	public var priority:Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( ID:String, format:VarType, priority:Int = 0 ) 
	{
		this.ID = ID;
		this.format = format;
		this.priority = priority;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 * @return num of values (byteSize) of the used format. e.g. position: 3
	 */
	private function get_size():Int
	{
		return RegisterType.getFloatSize( this.format );
	}
	
	/**
	 * 
	 * @return
	 */
	public function toString():String
	{
		return "[RegisterType;" + this.ID + ":" + this.format + "]";
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	/**
	 * translates the type to the flash format
	 * 
	 * @param	format
	 * @return
	 */
	public static function getVertexBufferFormat( format:VarType ):Context3DVertexBufferFormat
	{
		switch( format )
		{
			case VarType.TFloat: 	return Context3DVertexBufferFormat.FLOAT_1;
			case VarType.TFloat2: 	return Context3DVertexBufferFormat.FLOAT_2;
			case VarType.TFloat3: 	return Context3DVertexBufferFormat.FLOAT_3;
			case VarType.TFloat4: 	return Context3DVertexBufferFormat.FLOAT_4;
			case VarType.TInt: 		return Context3DVertexBufferFormat.BYTES_4; //?
			
			default: 		
				throw "not a vertexbuffer format";
		}
		
		return Context3DVertexBufferFormat.BYTES_4;
	}
	
	/**
	 * used to calculate the size checking the type
	 * e.g.: Float3 = 3; Int = 1; etc
	 * 
	 * @param	format
	 * @return
	 */
	public static function getFloatSize( format:VarType ):Int
	{
		switch( format )
		{
			case VarType.TNull: 	return 1;
			case VarType.TBool: 	return 1;
			case VarType.TFloat: 	return 1;
			case VarType.TFloat2: 	return 2;
			case VarType.TFloat3: 	return 3;
			case VarType.TFloat4: 	return 4;
			case VarType.TInt: 		return 1;
			
			case VarType.TMatrix (rows, columns, _):	
				return rows * columns;
			
			case VarType.TArray( type, length ):
				return RegisterType.getFloatSize( type ) * length;
			
			case VarType.TObject( fields ):
			{
				var current:Int = 0;
				
				for ( field in fields )
					current += RegisterType.getFloatSize( field.t );
				
				return current;
			}
			
			default:
				throw format + " has no defined size";
		}
		
		return 0;
	}
	
}

