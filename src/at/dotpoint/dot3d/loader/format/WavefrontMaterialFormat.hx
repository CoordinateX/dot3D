package at.dotpoint.dot3d.loader.format;

import at.dotpoint.dot3d.loader.parser.wavefront.WaveMTLParser;
import at.dotpoint.loader.format.ABaseDataFormat;
import at.dotpoint.loader.loader.ISingleDataLoader;
import at.dotpoint.loader.parser.ISingleDataParser;
import at.dotpoint.loader.loader.StringLoader;
import flash.net.URLRequest;

/**
 * ...
 * @author RK
 */
class WavefrontMaterialFormat extends ABaseDataFormat
{

	@:isVar public static var instance(get, null):WavefrontMaterialFormat;
	
	private static function get_instance():WavefrontMaterialFormat
	{
		if( WavefrontMaterialFormat.instance == null )
			WavefrontMaterialFormat.instance = new WavefrontMaterialFormat();
		
		return WavefrontMaterialFormat.instance;
	}
	
	// ************************************************************************ //
	// Constructor:
	// ************************************************************************ //	
	
	private function new() 
	{
		super( [ "mtl" ] );
	}
	
	/**
	 * 
	 * @return
	 */
	public override function createLoader( request:URLRequest ):ISingleDataLoader<Dynamic> 
	{
		return new StringLoader();
	}
	
	/**
	 * 
	 * @return
	 */
	public override function createParser( request:URLRequest ):ISingleDataParser<Dynamic,Dynamic> 
	{
		var directory:String = request.url;
			directory		 = directory.substring( 0, directory.lastIndexOf( "/" ) );
		
		return new WaveMTLParser( directory );
	}
}