package haxe.at.dotpoint.dot3d.loader.parser.wavefront;

import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.loader.processor.ADataProcessor;
import haxe.at.dotpoint.loader.processor.IDataProcessor;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class WavefrontMaterialLibraryParser extends ADataProcessor implements IDataProcessor<String,Vector<IMaterial>>
{
	
	/**
	 * 
	 */
	public var result(default:null):Vector<IMaterial>;
	
	// ------------------ //
	
	/**
	 * url textures are loaded relative to
	 */
	private var directoryURL:String;	
	
	/**
	 * 
	 */
	private var subParser:Array<WavefrontMaterialParser>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( directoryURL:String ) 
	{
		super();	
		
		this.directoryURL = directoryURL;
		this.subParser = new Array<WavefrontMaterialParser>();
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function start( input:String ):Void
	{
		this.setStatus( StatusEvent.STARTED );
		
		// -------------- //
		
		var obj:EReg = ~/newmtl\s([a-zA-Z0-9_]+)/g;
		var split:Array<String> = obj.split( input );
		
		var p:Int = 0; // start position
		var c:Int = 0; // current count (num parser)
		
		while( obj.matchSub( input, p ) )
		{
			var span:{ pos:Int, len:Int } = obj.matchedPos();
			
			p = span.pos + span.len;
			c++;
			
			this.subParser.push( new WavefrontMaterialParser( obj.matched(1), this.directoryURL, split[c] ) );	
		}
		
		this.result = new Vector<IMaterial>( this.subParser.length );
		this.parseMaterial();
	}
	
	/**
	 * starts the next material to parse, or dispatches complete event if all parsed
	 */
	private function parseMaterial():Void
	{
		if( this.subParser.length == 0 )
		{			
			this.setStatus( StatusEvent.COMPLETE );
			return;
		}
		
		var parser:WavefrontMaterialParser = this.subParser.pop();
			parser.addListener( this.onMaterialComplete );
			parser.start( null );		
	}
	
	/**
	 * when the current parsing material is done, save result and try the next one
	 */
	private function onMaterialComplete( event:Event ):Void
	{
		this.result[ this.subParser.length ] = event.target.result;
		this.parseMaterial();
	}
}