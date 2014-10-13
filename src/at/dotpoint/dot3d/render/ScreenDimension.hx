package at.dotpoint.dot3d.render;

import at.dotpoint.core.dispatcher.EventDispatcher;
import at.dotpoint.display.event.DisplayEvent;

/**
 * width and height of the viewport, defining the screen-render-size. any change in dimension
 * will dispatch an Event.RESIZE.
 * 
 * @author Gerald Hattensauer
 */
class ScreenDimension extends EventDispatcher
{
	
	/**
	 * width of the viewport in pixel
	 */
	public var width(default, null):Int;
	
	/**
	 * width / 2 of the viewport in pixel (for optimization purpose)
	 */
	public var width2(default, null):Float;
	
	/**
	 * height of the viewport in pixel
	 */
	public var height(default, null):Int;
	
	/**
	 * height / 2 of the viewport in pixel (for optimization purpose)
	 */
	public var height2(default, null):Float;
	
	/**
	 * aspect ratio between width and height
	 */
	public var ratio(default, null):Float;

	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	w width in pixel
	 * @param	h height in pixel
	 */
	public function new( w:Int, h:Int ) 
	{
		super();
		this.setDimension( w, h );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * In case of change, will dispatch Event.RESIZE and calulate all dimension
	 * dependend properties anew. Might cause a lot of recalculation so change seldom
	 * 
	 * @param	width in pixel
	 * @param	height in pixel
	 */
	public function setDimension( width:Int, height:Int ):Void 
	{
		if ( width <= 0 || height <= 0 ) throw "dimension must be greater than zero";
		if ( width == this.width && height == this.height ) return;		
		
		this.width  = width;		
		this.width2 = width * 0.5;
		
		this.height  = height;		
		this.height2 = height * 0.5;
		
		this.ratio = this.width / this.height;
		
		if( this.hasListener( DisplayEvent.RESIZE ) )
			this.dispatch( new DisplayEvent( DisplayEvent.RESIZE ) );
	}
}