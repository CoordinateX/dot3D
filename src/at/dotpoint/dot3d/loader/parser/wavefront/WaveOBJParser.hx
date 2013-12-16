package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.loader.parser.ABaseParser;
import at.dotpoint.loader.parser.ISingleDataParser;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.net.URLRequest;
import haxe.ds.Vector;

/**
 * Parses *.obj files by quickly scanning the file and delegating the detailed parsing
 * further to specialized parsers which in turn might start loading additional resources
 * like textures or start delegate on their own.
 * 
 * @author RK
 */
@:access( at.dotpoint.dot3d.loader.parser.wavefront )
//
class WaveOBJParser extends ABaseParser implements ISingleDataParser< String, Vector<Model> >
{
	
	private var input:String;
	private var output:Vector<Model>;
	
	// ------------------ //
	
	private var directoryURL:String;
	
	private var subParser:Array<WaveObjectParser>;
	private var materialLoader:DataRequest;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( directoryURL:String ) 
	{
		super();
		
		this.directoryURL = directoryURL;
		this.subParser = new Array<WaveObjectParser>();
	}
	
	// ************************************************************************ //
	// ISingleDataParser
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function parse( request:String ):Void
	{
		this.input = request;	
		
		this.setParsing();
		
		this.startMaterials();
		this.startObjects();
	}
	
	/**
	 * 
	 */
	public function close():Void
	{
		throw "close() not supported";
	}
	
	/**
	 * 
	 * @return
	 */
	public function getData():Vector<Model>
	{
		return this.output;
	}
	
	// ************************************************************************ //
	// parse material
	// ************************************************************************ //	
	
	/**
	 * load/parse the material parsed
	 */
	private function startMaterials():Void
	{
		var mtl:EReg = ~/mtllib\s([a-zA-Z0-9_]+\.mtl)/g;	
			mtl.match( this.input );
			
		this.materialLoader = DataRequest.createFromURL( this.directoryURL + "/" + mtl.matched(1) );
		this.materialLoader.load( this.onMaterialComplete );	
	}
	
	/**
	 * materials are done, create models and assign materials
	 */
	private function onMaterialComplete( event:Event ):Void
	{
		trace( "onMaterialComplete" );
		
		var materials:Vector<Material> = event.target.getData();
		
		for( p in 0...this.subParser.length )
		{
			var parser:WaveObjectParser = this.subParser[p];				
			var model:Model  			= this.output[p];				
			
			for( material in materials )
			{
				if( material.name == parser.materialName )	
				{
					model.material = material;
					break;
				}
			}
		}
		
		this.setComplete();
	}
	
	// ************************************************************************ //
	// parse objects
	// ************************************************************************ //	
	
	/**
	 * find seperate objects and delegate parsing for each individual object
	 */
	private function startObjects():Void
	{
		var obj:EReg = ~/#\sobject\s([a-zA-Z0-9_]+)/g;
		var split:Array<String> = obj.split( input );
		
		var p:Int = 0;
		var c:Int = 0;
		
		while( obj.matchSub( input, p ) )
		{
			var span:{ pos:Int, len:Int } = obj.matchedPos();
			
			p = span.pos + span.len;
			c++;
			
			this.subParser.push( new WaveObjectParser( obj.matched(1), split[c] ) );	
		}
		
		this.output = new Vector<Model>( this.subParser.length );
		this.parseObjects();		
	}	
	
	/**
	 * parse all single objects
	 */
	private function parseObjects():Void
	{
		var offset:Array<Int> = [1,1,1]; // default offset
		
		for( p in 0...this.subParser.length )
		{
			if( p > 0 )
			{
				var sig:MeshSignature = this.subParser[p - 1].getData().data.signature; //previous sig for offset
				
				for( j in 0...sig.size() )
				{
					offset[j] += sig.getNumEntries( sig.getTypeByIndex(j) ); 
				}
			}			
			
			var parser:WaveObjectParser = this.subParser[p];
				parser.offsets = offset;
				parser.parse( null );
			
			var model:Model = new Model( parser.getData() );
				model.name = parser.name;
				
			this.output[p] = model;
		}
		
		trace( "onObjectsComplete" );
	}
	
}