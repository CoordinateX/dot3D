package at.dotpoint.dot3d.render;

import flash.display.DisplayObject;
import flash.display.Stage3D;
import flash.display3D.Context3D;


/**
 * width and height of the viewport, defining the screen-render-size. any change in dimension
 * will dispatch an Event.RESIZE.
 * 
 * @author Gerald Hattensauer
 */
class Viewport extends ScreenDimension
{	
	
	/**
	 * Stage3D the rendering will take place
	 */
	public var stage3D(default, null):Stage3D;
	
	/**
	 * Context3D of the Stage3D; used by the RenderProcessor
	 */
	public var context(get, null):Context3D;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	stage
	 * @param	w
	 * @param	h
	 */
	public function new( stage:Stage3D, w:Int, h:Int ) 
	{		
		super( w, h );	
		this.stage3D = stage;	
	}		
	
	/**
	 * 
	 * @param	view
	 * @param	useStageDimensions
	 * @return
	 */
	public static function create( view:DisplayObject, useStageDimensions:Bool ):Viewport
	{
		if( view.stage == null )
			throw "must be added to the displaylist";
		
		var w:Int = Std.int( view.width );
		var h:Int = Std.int( view.height );
		
		if( useStageDimensions )
		{
			w = view.stage.stageWidth;
			h = view.stage.stageHeight;
		}
		
		return new Viewport( view.stage.stage3Ds[0], w, h );
	}
	
	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	private function get_context():Context3D
	{
		return this.stage3D.context3D;
	}
	
	
}