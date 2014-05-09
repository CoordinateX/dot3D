package at.dotpoint.dot3D;

import at.dotpoint.core.entity.Component;
import at.dotpoint.core.event.Event;
import at.dotpoint.core.event.event.EvaluateEvent;
import at.dotpoint.display.components.DisplayNode;
import at.dotpoint.display.components.DisplayNodeContainer;
import at.dotpoint.display.components.transform.Transform;
import at.dotpoint.dot3d.Space;
import at.dotpoint.math.vector.Matrix44;

/**
 * ...
 * @author RK
 */
class TransformSpace extends Transform
{
	
	private var transformLocalSpace:Transform;	
	private var invalidLocalSpace:Bool;
	
	private var transformWorldSpace:Transform;		
	private var invalidWorldSpace:Bool;
	
	private var ignoreTransformEvents:Bool; // used to avoid recursive/endless transform changed event	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		super();		
	}
	
	override function onEntityAdded():Void 
	{
		super.onEntityAdded();
		
		this.transformLocalSpace = this;
		this.transformLocalSpace.addEventListener( EvaluateEvent.CHANGED, this.onTransformChanged, false, 0, true );
		
		this.transformWorldSpace = new Transform();
		this.transformWorldSpace.addEventListener( EvaluateEvent.CHANGED, this.onTransformChanged, false, 0, true );
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //
	
	/**
	 * unless transform changes are currently ignored: transform changes trigger the
	 * worldspace transform of all children to be invalid. any change in world space
	 * renders the localspace old and vice versa.
	 * 
	 * @param	event Event.CHANGE, dispatched by a transform object
	 */
	private function onTransformChanged( event:Event ):Void 
	{
		if ( this.ignoreTransformEvents ) return;
		
		// --------------------- //
		
		if 		( event.target == this.transformLocalSpace ) this.invalidWorldSpace = true;
		else if ( event.target == this.transformWorldSpace ) this.invalidLocalSpace = true;		
		
		// --------------------- //
		
		if ( this.invalidWorldSpace || this.invalidLocalSpace ) 
			this.invalidateChildren();
		
		if ( this.invalidWorldSpace && this.invalidLocalSpace ) 
 			throw "irrecoverable state - world and local space transform have been invalidated at the same time";	
		
		// --------------------- //	
		
		//if ( this.hasEventListener( EvaluateEvent.CHANGED ) )
		//	this.dispatchEvent( new EvaluateEvent( EvaluateEvent.CHANGED ) );
	}
	
	/**
	 * sets the worldspace transform of all children invalid. updates the local space transform
	 * as world space is set invalid and there but be at least one transform up-to-date. local 
	 * transform is used to update worldspace transform
	 */
	private function invalidateChildren():Void
	{
		if ( this.invalidLocalSpace )
			this.updateLocalSpaceTransform();
		
		// ---------------- //	
		
		var graph:DisplayNodeContainer = cast this.entity.getComponent( DisplayNodeContainer );	
		
		if( graph != null )
		{
			for ( child in graph.children )
			{		
				var space:TransformSpace = cast child.getComponent( TransformSpace );				
					space.invalidateChildren();
					space.invalidWorldSpace = true;
			}
		}
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
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
		switch( space )
		{
			case Space.WorldSpace:
			{
				if ( this.invalidWorldSpace )
					this.updateWorldSpaceTransform();
				
				return this.transformWorldSpace;
			}				
				
			case Space.LocalSpace:
			{	
				if ( this.invalidLocalSpace )
					this.updateLocalSpaceTransform();
				
				return this.transformLocalSpace;
			}
			
			default:
			{
				throw "EntityContainer only supports WorldSpace and LocalSpace";				
			}				
		}
		
		return null;
	}
	
	/**
	 * local space transform of this object, or any transform of a parent changed and world space transform has to update
	 */
	private function updateWorldSpaceTransform()
	{			
		var transformed:Matrix44 = this.getTransform( Space.LocalSpace ).getMatrix();
		
		if ( this.getParent() != null )
		{
			var parentMatrix:Matrix44 = this.getParent().getTransform( Space.WorldSpace ).getMatrix(); 
			transformed = cast Matrix44.multiply( parentMatrix, transformed, new Matrix44() );	
		}		
		
		this.setTransform( this.transformWorldSpace, transformed );
		this.invalidWorldSpace = false;
	}
	
	/**
	 * world space transform changed and local space transform has to update
	 */
	private function updateLocalSpaceTransform()
	{		
		var transformed:Matrix44 = this.getTransform( Space.WorldSpace ).getMatrix();
		
		if ( this.getParent() != null )
		{
			var parentMatrix:Matrix44 = this.getParent().getTransform( Space.WorldSpace ).getMatrix(); 	
				parentMatrix.inverse();
				
			transformed = cast Matrix44.multiply( parentMatrix, transformed, new Matrix44() );
		}
		
		this.setTransform( this.transformLocalSpace, transformed );		
		this.invalidLocalSpace = false;
	}

	/**
	 * in order to avoid recursive and endless calls - ignore the change
	 * TODO: could be optimized setting the matrix internally (w/o dispatch)
	 * 
	 * @param	transform
	 * @param	matrix
	 */
	inline private function setTransform( transform:Transform, matrix:Matrix44 ):Void
	{
		this.ignoreTransformEvents = true;	
		
		transform.setMatrix( matrix );	
		
		this.ignoreTransformEvents = false;
	}
	
	private function getParent():DisplayObject3D
	{
		var graph:DisplayNode = cast this.entity.getComponent( DisplayNode );
		
		return cast graph.parent;
	}
}