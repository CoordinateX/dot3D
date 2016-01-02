package haxe.at.dotpoint.dot3d.bootstrapper;
import haxe.at.dotpoint.controls.IInputControlSystem;
import haxe.at.dotpoint.display.IDisplayEngine;

/**
 * @author RK
 */

interface IMainApplication
{

	/**
	 *
	 * @return
	 */
	public function getDisplayEngine():IDisplayEngine;

	/**
	 *
	 * @return
	 */
	public function getInputControlSystem():IInputControlSystem;

}