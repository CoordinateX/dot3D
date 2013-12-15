package at.dotpoint.dot3d.model.mesh;
import at.dotpoint.dot3d.model.register.RegisterSignature;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * Pure geometry without materials, just the raw mesh data in form of vertex data (position, normals, etc) and
 * a list of triangles that defines how the vertices build the mesh. Also stores the MeshBuffer which is used
 * to allocate the data for the GPU. checkout MeshData for more informations about the internal representation. 
 * 
 * @author RK
 */
class Mesh
{
	
	private static var IDCounter:Int;
	public var ID:Int;

	/**
	 * gpu allocated vertex and index buffers
	 */
	public var buffer:MeshBuffer;
	
	/**
	 * raw vertex data to manipulate
	 */
	public var data:MeshData;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	/**
	 * uses the signature to allocate the required space for the mesh and defining which
	 * types of vertex data are allowed to store and access. 
	 */
	public function new( signature:MeshSignature ) 
	{
		this.data = new MeshData( signature );
		this.buffer = new MeshBuffer();
		
		this.ID = Mesh.IDCounter++;
	}
	
	
}