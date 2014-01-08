package at.dotpoint.dot3d.loader.format;

import at.dotpoint.dot3d.loader.parser.wavefront.WaveOBJParser;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.loader.format.ABaseDataFormat;
import at.dotpoint.loader.format.StringFormat;
import at.dotpoint.loader.processor.IDataProcessor;
import at.dotpoint.loader.URLRequest;

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
	public override function createLoader( request:DataRequest ):IDataProcessor<URLRequest,Dynamic>
	{
		return StringFormat.instance.createLoader( request );
	}
	
	/**
	 * 
	 * @return
	 */
	public override function createParser( request:DataRequest ):IDataProcessor<Dynamic,Dynamic>
	{
		var directory:String = request.request.url;
			directory		 = directory.substring( 0, directory.lastIndexOf( "/" ) );
		
		return new WaveOBJParser( directory );
	}
}