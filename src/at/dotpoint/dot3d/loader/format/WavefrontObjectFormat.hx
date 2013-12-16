package at.dotpoint.dot3d.loader.format;

import at.dotpoint.dot3d.loader.parser.wavefront.WaveOBJParser;
import at.dotpoint.loader.format.ABaseDataFormat;
import at.dotpoint.loader.loader.ISingleDataLoader;
import at.dotpoint.loader.parser.ISingleDataParser;
import at.dotpoint.loader.loader.StringLoader;
import flash.net.URLRequest;

/**
 * ...
 * @author RK
 */
class WavefrontObjectFormat extends ABaseDataFormat
{

	@:isVar public static var instance(get, null):WavefrontObjectFormat;
	
	private static function get_instance():WavefrontObjectFormat
	{
		if( WavefrontObjectFormat.instance == null )
			WavefrontObjectFormat.instance = new WavefrontObjectFormat();
		
		return WavefrontObjectFormat.instance;
	}
	
	// ************************************************************************ //
	// Constructor:
	// ************************************************************************ //	
	
	private function new() 
	{
		super( [ "obj" ] );
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
		
		return new WaveOBJParser( directory );
	}
}