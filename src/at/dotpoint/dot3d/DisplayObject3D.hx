package at.dotpoint.dot3D;
import at.dotpoint.display.components.Boundings;
import at.dotpoint.display.components.DisplayNode;
import at.dotpoint.display.components.DisplayNodeContainer;
import at.dotpoint.display.components.transform.Transform;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.display.DisplayObjectContainer;
import at.dotpoint.dot3d.Space;
import at.dotpoint.math.vector.Matrix44;

/**
 * ...
 * @author RK
 */
class DisplayObject3D extends DisplayObjectContainer
{
	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		super();
	}
	
	override function initializeComponents():Void 
	{
		this.addComponent( new TransformSpace() 		);	// local+world space		
		this.addComponent( new DisplayNodeContainer() 	);	
		this.addComponent( new Boundings() 				);	
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //
	
	/**
	 * dont take yourself both, local and world space transform objects and manipulate them simultaniously.
	 * there must always be at least one valid transform. invalidating both at the same time will result in
	 * an error.
	 * 
	 * @param	space 	WorldSpace or LocalSpace
	 * @return 			Transform-Object in either WorldSpace or LocalSpace
	 */
	public function getTransform( space:Space ):Transform
	{
		return cast( this.transform, TransformSpace ).getTransform( space );
	}
	
}