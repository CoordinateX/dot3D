package at.dotpoint.dot3d.model.mesh;
import at.dotpoint.dot3d.model.register.RegisterSignature;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * ...
 * @author RK
 */
@:access(at.dotpoint.dot3d.model.mesh)
 //
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
	
	public function new( signature:MeshSignature ) 
	{
		this.data = new MeshData( signature );
		this.buffer = new MeshBuffer();
		
		this.ID = Mesh.IDCounter++;
	}
	
	
}