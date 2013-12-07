package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.container.RegisterTable;

/**
 * generated object including all informations relating to the vertex. this object is not used
 * internally to define and store a mesh, but can be used for convinient calculations and manipulations;
 * but make sure you stream any changes back to the mesh in case you want to apply them.
 * 
 * @author Gerald Hattensauer
 */
class Vertex extends RegisterTable
{

	public var index:Int;		
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?index:Int ) 
	{
		super( 1 );
		this.index = index;		
	}	

}