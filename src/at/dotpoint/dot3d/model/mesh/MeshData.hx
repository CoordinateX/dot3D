package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.container.IRegisterContainer;
import at.dotpoint.dot3d.model.register.container.RegisterTable;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.RegisterData;

/**
 * raw geometry storing data per vertex in a flat manner using RegisterData for each RegisterType;
 * so uv,position,normal,etc has its own RegisterData which stores the values for all vertices in an flat list
 * 
 * 
 * @author Gerald Hattensauer
 */
@:access( at.dotpoint.dot3d.model.register.RegisterData )
 //
class MeshData
{
	
	public var indices(default,null):Array<UInt>;
	public var vertices:IRegisterContainer;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( verticeContainer:IRegisterContainer ) 
	{
		this.vertices = verticeContainer;
	}
	
	/**
	 * creates the mesh using the given Vertex informations and saves the index list
	 * all vertices and its attributes are stored within a vertex stream, not as a
	 * simple list of Vertex-Objects so any reference is useless. Make sure the set
	 * index property of each vertex is set.
	 * 
	 * @param	vertices
	 * @param	indices		1 tupple of size 3 defines a face
	 */
	// TODO: setVertexList for better performance
	// TODO: strip/fans
	//
	public static function build( vertices:Array<Vertex>, indices:Array<UInt> ):MeshData
	{
		var container:IRegisterContainer = new RegisterTable( vertices.length );
		
		var mesh:MeshData = new MeshData( container );
			mesh.indices = indices;
		
		for ( vertex in vertices )	 	
		{
			mesh.setVertex( vertex );
		}
		
		return mesh;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * returns a list of TriangleFace-Objects defining the whole mesh relying on a correct index-list
	 * 1 index-tupple of size 3 defines a face; vertices that are shared between faces are the same object
	 */
	/*public function getFaceList():Array<TriangleFace>
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
	}*/

	/**
	 * 1 index-tupple of size 3 defines a face, make sure you start at one, the 3 following vertices
	 * are saved in the given face. the Vertex-Objects are not used internally.
	 */
	/*public function getFace( findex:Int, ?output:TriangleFace ):TriangleFace
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
	}*/
	
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
		
		for ( v in 0...this.vertices.numEntries )
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
		var vertex:Vertex = output != null ? output : new Vertex();
			vertex.index = vindex;
		
		var typelist:Array<RegisterType> = this.vertices.getRegisterTypes();
		var value:Array<Float> = new Array<Float>();
		
		for ( type in typelist )
		{
			value = this.vertices.getData( type, vertex.index, value );
			
			while( value.length > type.size )
					value.pop();
			
			vertex.setData( type, 0, value );
		}
		
		return vertex;
	}
	
	/**
	 * copies each attribute value of the vertex into the corresponding RegisterData. in case the RegisterType does not exist
	 * a new RegisterData will be created and stored in the mesh. Use this methode to change the mesh and its vertex-attributes
	 */
	public function setVertex( vertex:Vertex ):Void
	{
		var typelist:Array<RegisterType> = vertex.getRegisterTypes();
		var value:Array<Float> = new Array<Float>();
		
		for ( type in typelist )
		{
			value = vertex.getData( type, 0, value );
			
			while( value.length > type.size )
					value.pop();
			
			this.vertices.setData( type, vertex.index, value );
		}
	}
	
	
}