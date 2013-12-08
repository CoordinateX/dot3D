package at.dotpoint.dot3d.transform;

import at.dotpoint.core.event.EvaluateEvent;
import at.dotpoint.math.vector.IVector3;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * ...
 * @author Gerald Hattensauer
 */
@:access(at.dotpoint.dot3d.transform)
//
class Transform extends EventDispatcher
{

	public var position(default, null):Position;		
	public var rotation(default, null):Rotation;	
	public var scale(default, null):Scale;
	
	private var matrix:Matrix44;
	private var invalidMatrix:Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		super();
		
		this.position = new Position();	
		this.position.addEventListener( EvaluateEvent.CHANGED, this.onComponentChange, false, 0, true );
		
		this.rotation = new Rotation();
		this.rotation.addEventListener( EvaluateEvent.CHANGED, this.onComponentChange, false, 0, true );
		
		this.scale = new Scale();
		this.scale.addEventListener( EvaluateEvent.CHANGED, this.onComponentChange, false, 0, true );
		
		this.matrix = new Matrix44();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * invalidate matrix and dispatch; matrix will be updated on getMatrix();
	 */
	private function onComponentChange( event:Event ):Void 
	{				
		this.invalidMatrix = true;	
		this.setDirty();		
	}
	
	/**
	 * returns a clone of the internal matrix; validates in case of previous changes
	 */
	public function getMatrix():Matrix44 
	{
		if ( this.invalidMatrix )
			this.validate();
		
		return new Matrix44( this.matrix );
	}
	
	/**
	 * updates the internal state using the given transformation matrix.
	 * this is a relativly costly operation and happens immediatly
	 * 
	 * column-matrix; 
	 */
	public function setMatrix( matrix:Matrix44, ?scale:Vector3 ):Void
	{
		if ( !Matrix44.isEqual( this.matrix, matrix ) )
		{
			this.rotation.setMatrix( matrix );
			this.position.setMatrix( matrix );
			
			if( scale != null )
				this.scale.setVector( scale );
			
			this.matrix = new Matrix44( matrix );			
			this.invalidMatrix = false;					
		}		
	}
	
	/**
	 * updates the matrix using its internal position, rotation and scale object
	 */
	private function validate():Void
	{		
		this.matrix = this.rotation.getMatrix( this.matrix ); 									// validates and copies internal matrix onto this.matrix		
		
		if ( !this.scale.isIdentity() )						  		
			Matrix44.multiply( this.rotation.matrix, this.scale.getMatrix(), this.matrix );	 	// valid rotation internal * scale (new Matrix; could be pooled)

		this.matrix = this.position.getMatrix( this.matrix ); 									// copies position vector onto this.matrix			
		this.invalidMatrix = false;		
	}
	
	/**
	 * 
	 */
	private function setDirty( ?propertyID:String ):Void 
	{
		if ( this.hasEventListener( EvaluateEvent.CHANGED ) )
			this.dispatchEvent( new EvaluateEvent( EvaluateEvent.CHANGED, propertyID ) );
	}
	
}