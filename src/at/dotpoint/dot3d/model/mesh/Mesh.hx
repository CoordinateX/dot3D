package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.Log;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.tilezeit.IAllocate3D;
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;



/**
 * Stores the Attribute-Values for all vertices of a given mesh. Position, Normals, UV's etc.
 * Specifies pure geometry only, no materials
 */
class Mesh extends MeshData implements IAllocate3D
{

	public var indexBuffer:IndexBuffer3D;
	public var vertexBuffer:VertexBuffer3D;
	
	public var isAllocated(get,null):Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new( numVertices:Int ) 
	{
		super( numVertices );
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
	public static function build( vertices:Array<Vertex>, indices:Array<UInt> ):Mesh
	{
		var mesh:Mesh = new Mesh( vertices.length );
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
	
	private function get_isAllocated():Bool
	{
		return this.indexBuffer != null && this.vertexBuffer != null;
	}
	
	/**
	 * 
	 * @param	context
	 * @param	mesh
	 */
	public function allocate( context:Context3D ):Void
	{
		if ( this.isAllocated ) 
		{
			Log.warn( "already allocated" );
			this.dispose();
		}
		
		// ------------- //
		
		this.indexBuffer = context.createIndexBuffer( this.indices.length );
		this.indexBuffer.uploadFromVector( flash.Vector.ofArray( this.indices ), 0, this.indices.length );	
		
		// ------------- //
		
		var numVertices:Int = this.numVertices;
		var typeList:Array<RegisterType> = this.getDataTypes();
		
		var vlist:Array<Float> = new Array<Float>();			
		var vertex:Vertex = new Vertex();				
		
		for ( k in 0...numVertices )
		{
			vertex = this.getVertex( k, vertex );
			
			for ( type in typeList )
			{
				var data:Array<Float> = vertex.getData( type );
				
				for ( value in data )
				{
					vlist.push( value );
				}			
			}
		}	
		
		// ------------- //
		
		var numVData:Int = 0;
		
		for ( type in typeList )
		{
			numVData += type.size;		
		}
		
		// ------------- //
		
		this.vertexBuffer = context.createVertexBuffer( numVertices, numVData );
		this.vertexBuffer.uploadFromVector( flash.Vector.ofArray( vlist ), 0, numVertices );
	}	
	
	/**
	 * 
	 */
	public function dispose():Void
	{
		if ( this.indexBuffer != null )
		{
			this.indexBuffer.dispose();
			this.indexBuffer = null;
		}
		
		if ( this.vertexBuffer != null )
		{
			this.vertexBuffer.dispose();
			this.vertexBuffer = null;
		}
	}
}

