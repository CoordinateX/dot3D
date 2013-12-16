package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.loader.parser.ABaseParser;
import at.dotpoint.loader.parser.ISingleDataParser;
import flash.events.Event;
import haxe.ds.Vector;

/**
 * Parses *.mtl files by quickly scanning the file and delegating the detailed parsing
 * further to specialized parsers which in turn might start loading additional resources
 * like textures or start delegate on their own.
 * 
 * @author RK
 */
@:access( at.dotpoint.dot3d.loader.parser.wavefront )
//
class WaveMTLParser extends ABaseParser implements ISingleDataParser< String, Vector<Material> >
{
	
	private var input:String;
	private var output:Vector<Material>;
	
	// ------------------ //
	
	private var directoryURL:String;	
	private var subParser:Array<WaveMaterialParser>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( directoryURL:String ) 
	{
		super();	
		
		this.directoryURL = directoryURL;
		this.subParser = new Array<WaveMaterialParser>();
	}
	
	// ************************************************************************ //
	// ISingleDataParser
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function parse( input:String ):Void
	{
		this.input = input;
		
		this.setParsing();
		this.startMaterials();
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
	public function getData():Vector<Material>
	{
		return this.output;
	}
	
	// ************************************************************************ //
	// parse objects
	// ************************************************************************ //	
	
	/**
	 * find seperate materials and delegate parsing for each individual object
	 */
	private function startMaterials():Void
	{
		var obj:EReg = ~/newmtl\s([a-zA-Z0-9_]+)/g;
		var split:Array<String> = obj.split( this.input );
		
		var p:Int = 0;
		var c:Int = 0;
		
		while( obj.matchSub( input, p ) )
		{
			var span:{ pos:Int, len:Int } = obj.matchedPos();
			
			p = span.pos + span.len;
			c++;
			
			this.subParser.push( new WaveMaterialParser( obj.matched(1), this.directoryURL, split[c] ) );	
		}
		
		this.output = new Vector<Material>( this.subParser.length );
		this.parseMaterial();		
	}	
	
	/**
	 * starts the next material to parse
	 */
	private function parseMaterial():Void
	{
		if( this.subParser.length == 0 )
		{			
			this.setComplete();
			return;
		}
		
		var parser:WaveMaterialParser = this.subParser.pop();
			parser.addListener( null, null, this.onMaterialComplete );
			parser.parse( null );		
	}
	
	/**
	 * when the current parsing material is done, save result and try the next one
	 */
	private function onMaterialComplete( event:Event ):Void
	{
		this.output[ this.subParser.length ] = event.target.getData();
		this.parseMaterial();
	}
}