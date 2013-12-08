package at.dotpoint.dot3d.model.mesh;
import at.dotpoint.dot3d.model.register.RegisterType;

/**
 * ...
 * @author RK
 */
@:access(at.dotpoint.dot3d.model.mesh)
 //
class Mesh
{

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
	
	public function new() 
	{
		this.data = new MeshData();
		this.buffer = new MeshBuffer();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	type
	 * @param	index
	 * @param	values
	 */
	inline private function setVertexData( type:RegisterType, index:Int, values:Array<Float> ):Void
	{
		this.data.vertices.setData( type, index, values );
	}
	
	/**
	 * 
	 * @param	v1
	 * @param	v2
	 * @param	v3
	 */
	inline private function setFaceIndices( faceIndex:Int, input:Array<UInt> ):Void
	{
		this.data.setFaceIndices( faceIndex, input );
	}
}