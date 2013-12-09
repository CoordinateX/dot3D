package at.dotpoint.dot3d.model.mesh;
import at.dotpoint.dot3d.model.register.RegisterSignature;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * ...
 * @author RK
 */
class MeshSignature extends RegisterSignature
{	
	
	/**
	 * 
	 */
	public var numVertices(default, null):Int;
	
	/**
	 * 
	 */
	public var numFaces(default, null):Int;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( numVertices:Int, numFaces:Int, numRegisters:Int ) 
	{
		super( numRegisters );
		
		this.numVertices = numVertices;
		this.numFaces = numFaces;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	
}