package haxe.at.dotpoint.dot3d;

import haxe.at.dotpoint.display.DisplayEngine;

#if flash
import flash.at.dotpoint.dot3d.Flash3DEngine;
#elseif java
import lwjgl.at.dotpoint.dot3d.Java3DEngine;
#end

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
	#elseif java
	public static var instance(default, null):Java3DEngine = new Java3DEngine();
	#end
}