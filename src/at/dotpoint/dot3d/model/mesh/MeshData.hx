package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterContainer;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.RegisterData;

/**
 * raw geometry storing data per vertex in a flat manner using RegisterData for each RegisterType;
 * so uv,position,normal,etc has its own RegisterData which stores the values for all vertices in an flat list
 * 
 * position:	v1x, v1y, v1z, 	v2x, v2y, v2z, 	...
 * uv:			v1u, v1v, 		v2u, v2v, 		...
 * 
 * @author Gerald Hattensauer
 */
@:access( at.dotpoint.dot3d.model.register.RegisterData )
 //
class MeshData
{
	
	public var indices(default,null):Array<UInt>;
	public var vertices:RegisterContainer;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new( numVertices:Int ) 
	{
		this.numVertices = numVertices;		
		this.vertices = new RegisterContainer();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * returns a list of TriangleFace-Objects defining the whole mesh relying on a correct index-list
	 * 1 index-tupple of size 3 defines a face; vertices that are shared between faces are the same object
	 */
	public function getFaceList():Array<TriangleFace>
	{
		var vlist:Array<Vertex> = this.getVertexList();
		var list:Array<TriangleFace> = new Array<TriangleFace>();		

		var length:Int = this.indices.length;
		var findex:Int = 0;		

		while ( findex < length )
		{
			var face:TriangleFace = new TriangleFace( findex );
				face.vertices[0] = vlist[ this.indices[ findex + 0 ] ];
				face.vertices[1] = vlist[ this.indices[ findex + 1 ] ];
				face.vertices[2] = vlist[ this.indices[ findex + 2 ] ];

			list.push( face );
			findex += 3;
		}

		return list;
	}

	/**
	 * 1 index-tupple of size 3 defines a face, make sure you start at one, the 3 following vertices
	 * are saved in the given face. the Vertex-Objects are not used internally.
	 */
	public function getFace( findex:Int, ?output:TriangleFace ):TriangleFace
	{	
		if ( findex % 3 != 0 ) 						throw "index must be a multiple of 3";
		if ( findex > this.indices.length - 3 ) 	throw "index out of bounds (max: this.indices.length - 3)";
		
		if ( output == null ) 
			output = new TriangleFace( findex );
		
		output.index = findex;
		output.vertices[0] = this.getVertex( this.indices[ findex + 0 ] );
		output.vertices[1] = this.getVertex( this.indices[ findex + 1 ] );
		output.vertices[2] = this.getVertex( this.indices[ findex + 2 ] );	
		
		return output;
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// Vertex:
	
	/**
	 * creates for each vertex stored in the mesh an vertex object and fills it with all the data it has
	 * like uv, normal, position etc; each vertex is an object that is not associated with the geometry
	 * and any change in the vertex will not reflect on the mesh unless the vertex is set again via setVertex
	 */
	public function getVertexList():Array<Vertex>
	{
		var list:Array<Vertex> = new Array<Vertex>();
		
		for ( v in 0...this.numVertices )
		{
			list.push( this.getVertex( v ) );
		}
		
		return list;
	}
	
	/**
	 * creates and assembles an Vertex-Object out of all the registered attributes like uv, normal, etc
	 * for the vertex on the index position given in the argument. the vertex is an object that is not associated
	 * with the geometry and any change in the vertex will not reflect on the mesh unless the vertex is set again via setVertex
	 */
	public function getVertex( vindex:Int, ?output:Vertex ):Vertex
	{
		this.checkBounds( vindex );
		
		var vertex:Vertex = output != null ? output : new Vertex();
			vertex.index = vindex;
		
		for ( stream in this.vertices )
		{
			vertex.setData( stream.type, stream.getValues( vindex ) );
		}
		
		return vertex;
	}
	
	/**
	 * copies each attribute value of the vertex into the corresponding RegisterData. in case the RegisterType does not exist
	 * a new RegisterData will be created and stored in the mesh. Use this methode to change the mesh and its vertex-attributes
	 */
	public function setVertex( vertex:Vertex ):Void
	{
		this.checkBounds( vertex.index );
		
		var typelist:Array<RegisterType> = vertex.getDataTypes();
		
		for ( type in typelist )
		{
			var stream:RegisterData = this.getDataStream( type );
			
			if ( stream == null )
			{
				stream = new RegisterData( type, this.numVertices );
				this.addDataStream( stream );
			}
			
			stream.setValues( vertex.getData( type ), vertex.index );
		}
	}
	
	
}