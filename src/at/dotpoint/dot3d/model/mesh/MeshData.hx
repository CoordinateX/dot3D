package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterContainer;
import at.dotpoint.dot3d.model.register.RegisterSignature;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.RegisterData;
import haxe.ds.StringMap;
import haxe.ds.Vector;

/**
 * Defines raw geometry (no materials) by storing vertex data via RegisterContainers and several Indices describing
 * faces (each pointing to 3 vertices) but also the vertex itself (pointing to each unique vertex data).
 * <br/><br/>
 * Internally uv,position,normal,etc has its own RegisterData which stores the values for all vertices in an flat list.
 * Faces are build up in tuples of 3 indices each pointing to a vertex (which might be shared with other faces)
 * Vertices are build up of indices each pointing to each data-tuple (position is a tuple of 3), the tuple length of a 
 * vertex depends on the amount of different vertex data types stored (uv,position,etc).
 * <br/><br/>
 * Vertices are defined with indices pointing to each data in the RegisterContainer, this way only unique data is required
 * to be saved even if the data is reused several times on other vertices. e.g.: a cube has 8 unique vertex positions, but 
 * requires different normals for each of the 6 sides, normally you would need to create 4*6 vertices but here vertices
 * are build indirectly using indices to point to unique data. this way only 8 positions and 6 normals have to be stored
 * but 24 vertex indices. The mesh is build using face indices each face pointing to 3 vertex indices 
 * (which in turn point to their data).
 * 
 * @author Gerald Hattensauer
 */
class MeshData
{
	
	/**
	 * list with tuple of 3 indices to build a triangle - all together build a mesh
	 */
	private var faceIndices(default, null):Vector<Int>;
	
	/**
	 * position: 	0, 1, 2,	2, 3, 0,				...
	 * normal:		0, 0, 0,	0, 0, 0,	1, 1, 1, 	...
	 * uv:			0, 1, 2,	2, 3, 0,				...
	 * 					  ^		^
	 * 				   equal vertices can be removed
	 * 
	 * each value is an index to the vertex data: pos[0] = v1x, v1y, v1z
	 * each column is a vertrex; key is registerType.priority
	 */
	private var vertexIndices(default, null):RegisterContainer<Int>;	
	
	/**
	 * index:			  0				  1			...			  n
	 * 
	 * position:	v1x, v1y, v1z, 	v2x, v2y, v2z, 	...,	vnx, vny, vnz
	 * color:		v1r, v1g, v1b, 	v2r, v2g, v2b, 	...,	vnr, vng, vnb
	 * uv:			v1u, v1v, 		v2u, v2v, 		...,	vnu, vnv
	 */
	private var vertexData(default, null):RegisterContainer<Float>;
	
	// --------------------------------- //
	
	/**
	 * used to allocate the required space for the mesh and defining which
	 * types of vertex data are allowed to store and access. 
	 */
	public var signature(default,null):MeshSignature;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * uses the signature to allocate the required space for the mesh and defining which
	 * types of vertex data are allowed to store and access. 
	 */
	public function new( signature:MeshSignature ) 
	{
		this.signature 		= signature;
		
		this.faceIndices 	= new Vector<Int>( this.signature.numFaces * 3 );
		this.vertexIndices 	= new RegisterContainer<Int>(  this.signature  );
		this.vertexData 	= new RegisterContainer<Float>( this.signature  );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 * adds or overrides the given values to the RegisterData of the given type at the given index.
	 * <br/><br/>
	 * e.g.: position has 3 values, setting the first position data you have to use 0 as index, 
	 * the second position 1, etc. so no need to compensate for the way it is stored internally
	 * 
	 * @param	type type (ID) of which RegisterData you want the data from
	 * @param	index offset pointing to data just like in an array
	 * @param	values tuple you want to store; make sure it has the exact size of the type you store
	 */
	public function setVertexData( type:RegisterType, index:Int, data:Array<Float> ):Void
	{
		this.vertexData.setData( type, index, data );
	}
	
	public function getVertexData( type:RegisterType, index:Int, ?output:Array<Float> ):Array<Float>
	{
		return this.vertexData.getData( type, index, output );
	}
	
	/**
	 * adds or overrides a unique vertex by using the given registerIndices array
	 * where each value is an index pointing to the register data used for the vertex. the order
	 * is determined by the signature and you must provide an index for all RegisterTypes
	 * 
	 * @param	vertex unique vertex index
	 * @param	registerIndices	indices to data of registerType in the order of signature
	 */
	public function setVertexIndices( index:Int, registerIndices:Array<Int> ):Void
	{
		if( registerIndices.length != this.signature.size() )
			throw "register indices must cover the exact amount specified by the signature";
		
		var tmp:Array<Int> = new Array<Int>();
		
		for( t in 0...this.signature.size() )
		{
			var type:RegisterType = this.signature.getTypeByIndex( t );
			
			if(!this.vertexIndices.hasRegisterData( type ) )  // special size, so manually
				this.vertexIndices.setRegisterData( new RegisterData<Int>( IndexRegisterType.getType( type ), this.signature.numVertices ) ); 	
			
			// ----------- //
			
			tmp[0] = registerIndices[t];
			
			this.vertexIndices.setData( type, index, tmp );
		}		
	}
	
	/**
	 * adds or overrides a face using the given vertexIndices array where each value is an index
	 * pointing to a unique vertex. (set via setVertexIndices). 
	 * 
	 * @param	index
	 * @param	vertexIndices
	 */
	public function setFaceIndices( index:Int, vertexIndices:Array<Int> ):Void
	{
		if( vertexIndices.length != 3 )
			throw "face is build out of exactly 3 vertices";
		
		for( j in 0...3 )
		{
			this.faceIndices[ index * 3 + j ] = vertexIndices[j];
		}
	}
	
	// ************************************************************************ //
	// Stream
	// ************************************************************************ //
	
	/**
	 * converts internal representation
	 */
	public function createIndexStream():flash.Vector<UInt>
	{
		var total:Int = this.signature.numFaces * 3;
		var stream:flash.Vector<UInt> = new flash.Vector<UInt>( total, true );
		
		for( f in 0...total )
		{
			stream[f] = this.faceIndices[f];
		}
		
		return stream;
	}
	
	/**
	 *  converts internal representation
	 */
	public function createVertexStream():flash.Vector<Float>
	{
		var vertexSize:Int = this.signature.getTotalRegisterSize();
		
		var stream:flash.Vector<Float> = new flash.Vector<Float>( this.signature.numVertices * vertexSize, true );
		
		// -------------- //
		
		var typelist:Array<RegisterType> = this.signature.toArray();
		
		var tmpIndex:Array<Int>  = new Array<Int>();
		var tmpValue:Array<Float> = new Array<Float>();			
		
		var type:RegisterType = null;
		var curTypeSize:Int   = 0;
		
		// -------------- //
		
		for( v in 0...this.signature.numVertices )
		{
			curTypeSize = 0;
			
			for( t in 0...typelist.length )
			{
				type = typelist[t];			
				
				tmpIndex = this.vertexIndices.getData( type, v, tmpIndex );				
				tmpValue = this.vertexData.getData( type, tmpIndex[0], tmpValue );
				
				for( d in 0...type.size )
				{
					stream[ (v * vertexSize) + (curTypeSize) + d ] = tmpValue[ d ];
				}
				
				curTypeSize += type.size;
			}
		}
		
		return stream;
	}
}

// //////////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////////// //
// //////////////////////////////////////////////////////////////////////////// //

private class IndexRegisterType
{
	public static var table:StringMap<RegisterType>;
	
	public static function getType( original:RegisterType ):RegisterType
	{
		if( table == null )
			table = new StringMap<RegisterType>();
		
		var type:RegisterType = table.get( original.ID );
		
		if( type == null )
		{
			type = new RegisterType( original.ID, hxsl.Data.VarType.TInt, original.priority );
			table.set( original.ID, type );
		}
		
		return type;
	}
}