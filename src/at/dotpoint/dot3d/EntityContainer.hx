package at.dotpoint.dot3d;

import at.dotpoint.dot3d.transform.Transform;
import at.dotpoint.math.vector.Matrix44;
import flash.events.Event;
import flash.events.EventDispatcher;


/**
 * ...
 * @author Gerald Hattensauer
 */

class EntityContainer extends EventDispatcher
{
	
	public var parent(default, null):EntityContainer;	
	public var children(get, null):Array<EntityContainer>;
	
	// ---------------------- //
	
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
		
		this.transformLocalSpace = new Transform();
		this.transformLocalSpace.addEventListener( Event.CHANGE, this.onTransformChanged, false, 0, true );
		
		this.transformWorldSpace = new Transform();
		this.transformWorldSpace.addEventListener( Event.CHANGE, this.onTransformChanged, false, 0, true );
	}
	
	// ************************************************************************ //
	// Container
	// ************************************************************************ //			
	
	/**
	 * Children-List (Array)
	 */
	private function get_children():Array<EntityContainer>
	{
		if ( this.children == null ) this.children = new Array<EntityContainer>();
		return this.children;
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	/**
	 * adds the child to the display hierachy - any transformation to the container will 
	 * affect the worldspace transformation of the child; removes the child from its old
	 * container in case it had a parent.
	 * 
	 * @param	child
	 */
	public function addChild( child:EntityContainer ):Void
	{
		if ( child == this ) throw "Cannot add EntityContainer to itself";
		
		if ( child.parent != null ) 
			child.parent.removeChild( child );			
		
		this.children.push( child );		
		child.parent = this;
	}
	
	/**
	 * removes the child of the display hierachy in case its a child of this container
	 * @param	child
	 */
	public function removeChild( child:EntityContainer ):Void
	{
		if ( child.parent != this ) throw "EntityContainer must be child of the caller";		
		
		this.children.remove( child );	
		child.parent = null;
	}
	
	// ************************************************************************ //
	// Transform
	// ************************************************************************ //	
	
	/**
	 * unless transform changes are currently ignored: transform changes trigger the
	 * worldspace transform of all children to be invalid. any change in world space
	 * renders the localspace old and vice versa.
	 * 
	 * @param	event Event.CHANGE, dispatched by a transform object
	 */
	private function onTransformChanged(event:Event):Void 
	{
		if ( this.ignoreTransformEvents ) return;
		
		if 		( event.target == this.transformLocalSpace ) this.invalidWorldSpace = true;
		else if ( event.target == this.transformWorldSpace ) this.invalidLocalSpace = true;		
		
		if ( this.invalidWorldSpace || this.invalidLocalSpace ) 
			this.invalidateChildren();
		
		if ( this.invalidWorldSpace && this.invalidLocalSpace ) 
 			throw "irrecoverable state - world and local space transform have been invalidated at the same time";	
		
		if ( this.hasEventListener( Event.CHANGE ) )
			this.dispatchEvent( new Event( Event.CHANGE ) );
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
		
		for ( child in this.children )
		{			
			child.invalidateChildren();
			child.invalidWorldSpace = true;
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
				return null;
			}				
		}
	}
	
	/**
	 * local space transform of this object, or any transform of a parent changed and world space transform has to update
	 */
	private function updateWorldSpaceTransform()
	{			
		var transformed:Matrix44 = this.getTransform( Space.LocalSpace ).getMatrix();
		
		if ( this.parent != null )
		{
			var parentMatrix:Matrix44 = this.parent.getTransform( Space.WorldSpace ).getMatrix(); 
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
		
		if ( this.parent != null )
		{
			var parentMatrix:Matrix44 = this.parent.getTransform( Space.WorldSpace ).getMatrix(); 	
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
}