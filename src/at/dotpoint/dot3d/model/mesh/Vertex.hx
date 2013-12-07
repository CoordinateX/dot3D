package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterContainer;
import at.dotpoint.ICloneable;
import at.dotpoint.dot3d.model.register.RegisterData;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * generated object including all informations relating to the vertex. this object is not used
 * internally to define and store a mesh, but can be used for convinient calculations and manipulations;
 * but make sure you stream any changes back to the mesh in case you want to apply them.
 * 
 * @author Gerald Hattensauer
 */
class Vertex extends RegisterContainer
{

	public var index:Int;		
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?index:Int ) 
	{
		super( 0 );
		this.index = index;		
	}	

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * searches for the given attribute and returns it's data when found, or null
	 * the data can usually be interpreted as Vector2 or Vector3
	 */
	public function getData( type:RegisterType, ?output:Array<Float> ):Array<Float>
	{
		var stream:RegisterData = this.getDataStream( type );
		
		if ( stream != null )	return stream.getValues( 0, output );
		else					return null;
	}
	
	/**
	 * adds the given AttributeType to the vector and sets its data
	 */
	public function setData( type:RegisterType, values:Array<Float> ):Void
	{
		var stream:RegisterData = this.getDataStream( type );
		
		if ( stream == null )
		{
			stream = new RegisterData( type, 0 );
			this.addDataStream( stream );
		}
		
		stream.setValues( values, 0 );
	}
	
}