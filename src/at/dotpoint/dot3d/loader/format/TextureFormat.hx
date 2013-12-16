package at.dotpoint.dot3d.loader.format;

import at.dotpoint.core.ds.VectorUtil;
import at.dotpoint.loader.format.ABaseDataFormat;
import at.dotpoint.loader.format.BitmapFormat;
import at.dotpoint.loader.loader.ISingleDataLoader;
import at.dotpoint.loader.parser.ISingleDataParser;
import flash.net.URLRequest;

/**
 * ...
 * @author RK
 */
class TextureFormat extends ABaseDataFormat
{

	@:isVar public static var instance(get, null):TextureFormat;
	
	private static function get_instance():TextureFormat
	{
		if( TextureFormat.instance == null )
			TextureFormat.instance = new TextureFormat();
		
		return TextureFormat.instance;
	}
	
	// ************************************************************************ //
	// Constructor:
	// ************************************************************************ //	
	
	private function new() 
	{
		super( VectorUtil.toArray( BitmapFormat.instance.extensions ) );
	}
	
	/**
	 * 
	 * @return
	 */
	public override function createLoader( request:URLRequest ):ISingleDataLoader<Dynamic> 
	{
		return BitmapFormat.instance.createLoader( request );
	}
	
}