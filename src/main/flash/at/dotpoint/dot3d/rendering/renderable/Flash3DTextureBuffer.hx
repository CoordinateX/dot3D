package flash.at.dotpoint.dot3d.rendering.renderable;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.utils.ByteArray;
import haxe.at.dotpoint.display.renderable.bitmap.BitmapData;
import haxe.at.dotpoint.logger.Log;

/**
 * ...
 * @author RK
 */
class Flash3DTextureBuffer
{

	/**
	 * 
	 */
	public var data:BitmapData;
	
	/**
	 * 
	 */
	public var buffer:Texture;
	
	/**
	 * 
	 */
	public var isAllocated(get,null):Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( data:BitmapData ) 
	{
		this.data = data;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	private function get_isAllocated():Bool
	{
		return this.buffer != null;
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	// allocate / dispose
	
	/**
	 * 
	 * @param	context
	 * @param	mesh
	 */
	public function allocate( context:Context3D ):Void
	{
		if ( this.isAllocated ) 
		{
			Log.warn( "already allocated: " + Log.getCallstack() );
			this.dispose();
		}
		
		var bytes:ByteArray = this.data.pixels.getData();
			bytes.endian = flash.utils.Endian.LITTLE_ENDIAN;
			bytes.position = 0;
			
		var bitmapdata:flash.display.BitmapData = new flash.display.BitmapData( this.data.width, this.data.height );
			bitmapdata.setPixels( bitmapdata.rect, bytes );
		
		this.buffer = context.createTexture( this.data.width, this.data.height, Context3DTextureFormat.BGRA, false );
		this.buffer.uploadFromByteArray( bytes, 0, 0 );
		//this.buffer.uploadFromBitmapData( bitmapdata, 0 );
	}
	
	/**
	 * 
	 */
	public function dispose():Void
	{
		if ( this.buffer != null )
		{
			this.buffer.dispose();
			this.buffer = null;
		}
	}
}