package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.loader.parser.ABaseParser;
import at.dotpoint.loader.parser.ISingleDataParser;

/**
 * Parses a single material out of an *.mtl file which might contain a lot of them
 * although it is a regular SingleDataParser should not be used like it and can 
 * only be created from WaveMTLParser
 * 
 * @author RK
 */
class WaveMaterialParser extends ABaseParser implements ISingleDataParser<String,Material>
{

	private var input:String;
	private var output:Material;
	
	// ------------------ //
	
	public var name:String;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new( name:String, data:String ) 
	{
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
		throw "close() not supported"
	}
	
	/**
	 * 
	 * @return
	 */
	public function getData():Material
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