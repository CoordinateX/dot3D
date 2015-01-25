package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.core.event.StatusEvent;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.loader.processor.ADataProcessor;
import at.dotpoint.loader.processor.IDataProcessor;
import haxe.ds.Vector;
import hxsl.Shader;

/**
 * Parses *.mtl files by quickly scanning the file and delegating the detailed parsing
 * further to specialized parsers which in turn might start loading additional resources
 * like textures or start delegate on their own.
 * 
 * @author RK
 */
@:access( at.dotpoint.dot3d.loader.parser.wavefront )
//
class WaveMTLParser extends ADataProcessor implements IDataProcessor< String, Vector<Material<Shader>> >
{
	
	private var input:String;
	public var result(default,null):Vector<Material<Shader>>;
	
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
	public function start( input:String ):Void
	{
		this.input = input;
		
		this.setStatus( StatusEvent.STARTED );
		this.startMaterials();
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
		
		this.result = new Vector<Material<Shader>>( this.subParser.length );
		this.parseMaterial();		
	}	
	
	/**
	 * starts the next material to parse
	 */
	private function parseMaterial():Void
	{
		if( this.subParser.length == 0 )
		{			
			this.setStatus( StatusEvent.COMPLETE );
			return;
		}
		
		var parser:WaveMaterialParser = this.subParser.pop();
			parser.addStatusListener( this.onMaterialComplete );
			parser.start( null );		
	}
	
	/**
	 * when the current parsing material is done, save result and try the next one
	 */
	private function onMaterialComplete( event:StatusEvent ):Void
	{
		this.result[ this.subParser.length ] = cast cast( event.target, IDataProcessor<Dynamic,Dynamic>).result;
		this.parseMaterial();
	}
}