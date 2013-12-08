package at.dotpoint.dot3d.model.material;

import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;

/**
 * ...
 * @author Gerald Hattensauer
 */
class Texture
{

	public var ID(default,null):String;	
	
	public var bitmaps:Array<BitmapData>;
	public var texture:flash.display3D.textures.Texture;
	
	public var width(default, null):Int;
	public var height(default, null):Int;
	
	public var isCubic(default, null):Bool;
	public var isAllocated(get,null):Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ID:String, w:Int, h:Int ) 
	{
		this.ID = ID;	
		
		this.width = w;
		this.height = h;
		
		this.bitmaps = new Array<BitmapData>();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	private function get_isAllocated():Bool
	{
		return this.texture != null;
	}
	
	/**
	 * 
	 * @param	context
	 */
	public function allocate( context:Context3D ):Void
	{
		this.texture = context.createTexture( this.width, this.height, Context3DTextureFormat.BGRA, false );
		
		for ( i in 0...this.bitmaps.length )
		{			
			this.texture.uploadFromBitmapData( this.bitmaps[i], i );
		}
	}
	
	public function dispose():Void
	{
		if ( this.texture != null )
		{
			this.texture.dispose();
			this.texture = null;
		}
	}
}