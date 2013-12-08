package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.dot3d.model.register.RegisterContainer;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.RegisterData;
import haxe.ds.StringMap;

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
	 * triangle:	   0		   1					...
	 * 
	 * position: 	0, 1, 2,	2, 3, 0,				...
	 * normal:		0, 0, 0,	0, 0, 0,	1, 1, 1, 	...
	 * uv:			0, 1, 2,	2, 3, 0,				...
	 * 					  ^		^
	 * 				   equal vertices
	 * 
	 * each value is an index to the vertex data: pos[0] = v1x, v1y, v1z
	 * each tuple of 3 makes a face/triangle
	 * each column is a vertrex
	 */
	private var indices(default, null):Array< Array<UInt> >;
	
	/**
	 * index:			  0				  1			...			  n
	 * 
	 * position:	v1x, v1y, v1z, 	v2x, v2y, v2z, 	...,	vnx, vny, vnz
	 * color:		v1r, v1g, v1b, 	v2r, v2g, v2b, 	...,	vnr, vng, vnb
	 * uv:			v1u, v1v, 		v2u, v2v, 		...,	vnu, vnv
	 */
	private var vertices(default, null):RegisterContainer;
	
	// ------------------------------ //
	
	public var numVertices(get, null):Int;
	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		this.vertices = new RegisterContainer();
		this.indices = new Array< Array<UInt> >();
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	public function get_numVertices():Int
	{
		return this.indices[0] == null ? 0 : this.indices[0].length;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	index
	 * @param	?output
	 * @return
	 */
	public function getVertexData( index:Int, ?output:Array<Float> ):Array<Float>
	{
		output = output != null ? output : new Array<Float>();
		
		// ----------- //
		
		var types:Array<RegisterType> = this.vertices.getRegisterTypes();
		var length:Int = this.vertices.getNumTypes();
		
		for( t in 0...length )
		{
			var type:RegisterType = types[t];
			var tlist:Array<UInt> = this.indices[t];
			
			var data:Array<Float> = this.vertices.getData( type, tlist[index] );
			
			for( i in 0...data.length )
				output.push( data[i] );
		}
		
		return output;
	}
	
	/**
	 * beware to send the data in the right order!
	 * index list own ds?
	 * 
	 * @param	faceIndex
	 * @param	dataIndices	[v1p, v1n, 	v2p, v2n, 	v3p, v3n]
	 */
	public function setFaceIndices( faceIndex:Int, input:Array<UInt> ):Void
	{			
		var length:Int = this.vertices.getNumTypes();
		
		if( input.length != 3 * length )
			throw "must provide exactly 3 vertices * " + length;		
		
		for( v in 0...3 )
		{
			for( t in 0...length )
			{
				var tlist:Array<UInt> = this.indices[t]; 		// position, normal, ...
				
				if( tlist == null )
				{
					tlist = new Array<UInt>();
					this.indices[t] = tlist;
				}
				
				tlist[ faceIndex * 3 + v ] = input[ v * length + t ];
				
				// möglich aus input signatur + lookup table doppelte vertices zu filtern
				// vertex-input.join("/") und dann hashmap ... ist simple
			}
		}
	}
		
}