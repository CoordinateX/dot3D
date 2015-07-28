package haxe.at.dotpoint.dot3d;

#if flash
import flash.at.dotpoint.dot3d.Flash3DEngine;
#end

import haxe.at.dotpoint.display.DisplayEngine;

/**
 * ...
 * @author RK
 */
class Stage3DEngine extends DisplayEngine
{

	/**
	 * 
	 */	
	#if flash
	public static var instance(default, null):Flash3DEngine = new Flash3DEngine(); 	
	#end
}