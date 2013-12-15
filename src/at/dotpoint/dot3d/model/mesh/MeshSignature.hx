package at.dotpoint.dot3d.model.mesh;
import at.dotpoint.dot3d.model.register.RegisterSignature;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * used to allocate the required space for the mesh and defining which
 * types of vertex data are allowed to store and access. 
 * 
 * DO NOT CHANGE WHEN ALREADY USED BY A MESHDATA
 * 
 * @author RK
 */
class MeshSignature extends RegisterSignature
{	
	
	/**
	 * amount of unique vertices. faces sharing a vertex without having 
	 * any vertex data different (like normals) can use the exact same
	 * vertex and therefor should not be counted towards the total amount
	 * of unique vertices.
	 */
	public var numVertices(default, null):Int;
	
	/**
	 * amount of faces. a face is a tuple of 3 vertices
	 */
	public var numFaces(default, null):Int;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * @param	numVertices	amount of unique vertices (shared do not count towards this)
	 * @param	numFaces amount of faces. a face is a tuple of 3 vertices
	 * @param	numRegisters amount of different types of vertex data (uv, normal, etc)
	 */
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