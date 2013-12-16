package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.loader.parser.ABaseParser;
import at.dotpoint.loader.parser.ISingleDataParser;
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
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( directoryURL:String ) 
	{
		super();	
		this.directoryURL = directoryURL;
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
		this.setParsing();
		this.start();
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
	// parseLines
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function start():Void
	{			
		this.setComplete();
	}
}