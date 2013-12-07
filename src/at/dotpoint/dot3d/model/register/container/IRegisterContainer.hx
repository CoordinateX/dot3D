package at.dotpoint.dot3d.model.register.container;

import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * ...
 * @author Gerald Hattensauer
 */

interface IRegisterContainer
{
	
	/**
	 * number of entries data can be get from and set to
	 */
	public var numEntries(default, null):Int;
	
	// ----------------------------------------------------------------------- //
	
	/**
	 * searches for the given attribute and returns it's data when found, or null
	 * the data can usually be interpreted as Vector2 or Vector3
	 */
	public function getData( type:RegisterType, index:Int, ?output:Array<Float> ):Array<Float>;
	
	/**
	 * adds the given values to the RegisterData of the given index
	 */
	public function setData( type:RegisterType, index:Int, values:Array<Float> ):Void;
	
	// ----------------------------------------------------------------------- //
	// RegisterTypes:
	
	/**
	 * creates a list of all existing RegisterType saved for this mesh therefore
	 * lists all register-attribute-types that are avaible
	 */
	public function getRegisterTypes():Array<RegisterType>;
	
	/**
	 * checks if the given RegisterType exists already in form of a RegisterData
	 */
	public function hasRegisterType( type:RegisterType ):Bool;
	
}