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
	
	public function new( data:MeshData ) 
	{
		this.data = data;
		this.buffer = new MeshBuffer();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	faceIndex
	 * @param	normals
	 */
	inline private function setFaceData( type:RegisterType, index:Int, values:Array<Float> ):Void
	{
		for( j in 0...3 )
		{
			var vertexIndex:Int = this.data.indices[ index + j ];
			this.data.vertices.setData( type, vertexIndex, values );
		}
		
	}
	
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
	inline private function setIndexData( v1:Int, v2:Int, v3:Int ):Void
	{
		this.data.indices.push( v1 );
		this.data.indices.push( v2 );
		this.data.indices.push( v3 );
	}
}