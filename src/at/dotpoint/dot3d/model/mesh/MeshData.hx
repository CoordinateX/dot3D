package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterContainer;
import at.dotpoint.dot3d.model.register.RegisterSignature;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.RegisterData;
import haxe.ds.StringMap;
import haxe.ds.Vector;

/**
 * raw geometry storing data per vertex in a flat manner using RegisterData for each RegisterType;
 * so uv,position,normal,etc has its own RegisterData which stores the values for all vertices in an flat list
 * 
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
	 * 				   equal vertices are removed
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
	 * 
	 */
	public var signature(default,null):MeshSignature;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
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
	 * 
	 * @param	type
	 * @param	data
	 */
	public function setVertexData( type:RegisterType, index:Int, data:Array<Float> ):Void
	{
		this.vertexData.setData( type, index, data );
	}
	
	/**
	 * 
	 * @param	vertex
	 * @param	registerIndices	order of signature
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
	 * 
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
	 * 
	 * @return
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