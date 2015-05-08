package at.dotpoint.dot3d.geometry.material;

import at.dotpoint.display.geometry.material.IMaterial;
import at.dotpoint.display.geometry.material.MaterialSignature;
import at.dotpoint.display.register.RegisterHelper;
import at.dotpoint.display.register.RegisterType;
import at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class DiffuseColorMaterial implements IMaterial
{

	/**
	 * 
	 */
	public var color:Vector3;
	
	/**
	 * 
	 */
	private var signature:MaterialSignature;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?color:Vector3 ) 
	{
		this.color = color != null ? color : new Vector3( Math.random(), Math.random(), Math.random() );
		
		this.signature = new MaterialSignature( "DiffuseColor", 1 );
		this.signature.addRegisterType( RegisterHelper.M_COLOR );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	inline public function getMaterialSignature():MaterialSignature
	{
		return this.signature;
	}

	/**
	 * 
	 * @param	type
	 * @return
	 */
	inline public function getRegisterData<T:Dynamic>( type:RegisterType ):T
	{
		if( type.ID == RegisterHelper.M_COLOR.ID )
			return cast this.color;
		
		return null;
	}
	
	/**
	 * 
	 * @param	type
	 * @param	data
	 */
	public function setRegisterData( type:RegisterType, data:Dynamic ):Void
	{
		return;
	}
	
}