package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.loader.processor.ADataProcessor;
import at.dotpoint.loader.processor.IDataProcessor;
import haxe.ds.StringMap;

/**
 * Parses a single object out of an *.obj file which might contain a lot of them
 * although it is a regular SingleDataParser should not be used like it and can 
 * only be created from WaveOBJParser
 * 
 * @author RK
 */
class WaveObjectParser extends ADataProcessor implements IDataProcessor<String,Mesh>
{

	private var input:String;
	public var result(default,null):Mesh;
	
	// ------------------ //
	
	/**
	 * mesh has no name, so WaveOBJParser sets it on the model
	 */
	public var name:String;
	
	/**
	 * mesh has no material, so WaveOBJParser sets it on the model
	 */
	public var materialName:String;
	
	// ------------------ //
	
	/**
	 * determine unique vertex
	 */
	private var vertexLookup:StringMap<Vertex>;
	private var numUniqueVertices:Int;
	
	/**
	 * register indices for vertices do have an offset depending on previously parsed
	 * objects. e.g.: f 10/8/12 9/5/12 13/6/12 must be substracted with 8/4/6
	 */
	public var offsets:Array<Int>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new( name:String, data:String ) 
	{
		super();
		
		this.name = name;
		this.input = data;
	}
	
	// ************************************************************************ //
	// ISingleDataParser
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function start( input:String ):Void
	{		
		this.setStatus( StatusEvent.STARTED );
		this.parse();
	}
	
	// ************************************************************************ //
	// parseLines
	// ************************************************************************ //	
	
	/**
	 * scannes the data to extract the mesh signature and then  proceeds to parse
	 * it in detail. in this process it first  builds a face list to determine 
	 * unique vertices and later on uses the resulting vertex-list to fully build
	 * the mesh. the material name will be extracted aswell but has to be set
	 * manually into the model afterwards. (same goes for the model/object name)
	 */
	private function parse():Void
	{		
		// position
		var vreg:EReg = ~/#\s+([0-9]+)\s+vertices/;	
			vreg.match( this.input );
		
		// faces
		var freg:EReg = ~/#\s+([0-9]+)\s+faces/;
			freg.match( this.input );	
		
		// ------------------------------ //	
		// count registers:
		
		var numRegisters:Int = 1;
		
		//normal:
		var nreg:EReg = ~/#\s+([0-9]+)\s+vertex\snormals/;
		var hasN:Bool = nreg.match( this.input );
		
		if(	hasN ) 
			numRegisters++;
		
		//uv:
		var treg:EReg = ~/#\s+([0-9]+)\s+texture\scoords/;
		var hasT:Bool = treg.match( this.input );
		
		if(	hasT ) 
			numRegisters++;
		
		// ------------------------------ //	
		// pre calculate unique vertices
		
		var vertices:Array<Vertex> = this.parseFaces(); // parse first to determine unique vertices
		
		// ------------------------------ //	
		// signature/mesh:
		
		var numVertices:Int = this.numUniqueVertices;
		var numFaces:Int 	= Std.parseInt( freg.matched(1) );
		
		var signature:MeshSignature = new MeshSignature( numVertices, numFaces, numRegisters );
			signature.addType( Register.VERTEX_POSITION, Std.parseInt( vreg.matched(1) ) );
		
		if(	hasT )	signature.addType( Register.VERTEX_UV, 		 Std.parseInt( treg.matched(1) ) );
		if(	hasN ) 	signature.addType( Register.VERTEX_NORMAL, 	 Std.parseInt( nreg.matched(1) ) );		
		
		this.result = new Mesh( signature );
		
		// ------------------------------ //		
		// fill meshdata:
		
		this.parseVertexData( Register.VERTEX_POSITION, ~/v\s+(\-?[0-9]+\.?[0-9]*\s){3}/ );	
		
		if( hasN ) this.parseVertexData( Register.VERTEX_NORMAL, ~/vn\s+(\-?[0-9]+\.?[0-9]*\s){3}/ );
		if( hasT ) this.parseVertexData( Register.VERTEX_UV,	 ~/vt\s+(\-?[0-9]+\.?[0-9]*\s){2}/ );
		
		this.buildMesh( vertices );
		this.parseMaterialName();
		
		// ------------------------------ //
		
		this.setStatus( StatusEvent.COMPLETE );
	}
	
	// ---------------------------------------------------------------------------------- //
	// ---------------------------------------------------------------------------------- //
	// FACES
	
	/**
	 * disassembles each face line into its register-indices and checks if the
	 * combination of register data has already occured and if so, does not add
	 * a new vertex but reference to the already set one. the resulting list
	 * does contain duplicate Vertex-Objects but reference to a unique one - use
	 * index and you may only set the data if the index hasn't been set already
	 */
	private function parseFaces():Array<Vertex>
	{
		var faceList:Array<Vertex> = new Array<Vertex>();
		
		this.vertexLookup = new StringMap<Vertex>();
		this.numUniqueVertices = 0;
		
		// ------------------------------ //
		
		var line:EReg = ~/f\s[0-9\/\s]+/;		
		var p:Int = 0;
		
		while( line.matchSub( this.input, p ) )
		{			
			var vertices:Array<String> = line.matched(0).split(" ");
			
			for( v in 1...4 ) // skip "f", 3 vertices
				faceList.push( this.setFaceVertex( vertices[v] ) );
			
			p = line.matchedPos().pos + line.matchedPos().len; 			
		}
		
		return faceList;
	}
	
	/**
	 * creates a new Vertex-Object in case the given register-index combination
	 * (signature) is new and in either case returns a vertex to the given signature.
	 */
	private function setFaceVertex( sig:String ):Vertex
	{
		if( !this.vertexLookup.exists( sig ) )
		{
			var splitted:Array<String> = sig.split("/");
			var data:Array<Int> = new Array<Int>();
			
			for( d in 0...splitted.length )
				data[d] = Std.parseInt( splitted[d] ) - this.offsets[d]; //starting at 0, obj does at 1
			
			var vertex:Vertex = new Vertex();
				vertex.index = this.numUniqueVertices;
				vertex.data = data;
			
			this.vertexLookup.set( sig, vertex );
			this.numUniqueVertices++;
		}
		
		return this.vertexLookup.get( sig );
	}
	
	// ---------------------------------------------------------------------------------- //
	// ---------------------------------------------------------------------------------- //
	// VERTEX DATA

	/**
	 * uses the provided RegEx to parse through each line and saves the data
	 * into the mesh using the given RegisterType
	 */
	private function parseVertexData( type:RegisterType, line:EReg ):Void
	{
		var data:Array<Float> = new Array<Float>();
		
		var size:Int = type.size + 1;
		
		var p:Int = 0;
		var i:Int = 0;
		
		while( line.matchSub( this.input, p ) )
		{				
			var splitted:Array<String> = line.matched(0).split("  ").join(" ").split(" ");
			
			for( d in 1...size ) // skip type identifier, size: data + skip
				data[d - 1] = Std.parseFloat( splitted[d] );
			
			this.result.data.setVertexData( type, i++, data );	
			
			p = line.matchedPos().pos + line.matchedPos().len; 	
		}
	}
	
	// ---------------------------------------------------------------------------------- //
	// ---------------------------------------------------------------------------------- //
	// Mesh:
	
	/**
	 * creates the mesh by using the previously parsed face data, accounting for possible
	 * duplicated vertices. first creates all unique vertices, and later fills the "indexbuffer"
	 */
	private function buildMesh( list:Array<Vertex> ):Void
	{
		var data:Array<Int> = new Array<Int>();
		
		for( v in 0...list.length )
		{
			this.result.data.setVertexIndices( list[v].index, list[v].data ); // brutally overrides previous data, although its the same			
			
			data[v % 3] = list[v].index;
			
			if( v % 3 == 2 )
				this.result.data.setFaceIndices( Std.int( v / 3 ), data );
		}
	}
	
	/**
	 * usemtl wire_214228153
	 */
	private function parseMaterialName():Void
	{
		var mreg:EReg = ~/usemtl\s+([a-zA-Z0-9_]+)\s*/;	
			mreg.match( this.input );
		
		this.materialName = mreg.matched(1);
	}
}

private class Vertex
{
	public var index:Int;
	public var data:Array<Int>;
	
	public function new(){	}
}