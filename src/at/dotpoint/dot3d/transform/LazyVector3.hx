package at.dotpoint.dot3d.transform;

import at.dotpoint.core.event.EvaluateEvent;
import at.dotpoint.math.MathUtil;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * Manages a Vector and notifies any listener about changes
 * @author Gerald Hattensauer
 */
class LazyVector3 extends EventDispatcher
{

	private var value:Vector3;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var z(get, set):Float;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( x:Float = 0, y:Float = 0, z:Float = 0 ) 
	{
		super();
		this.value = new Vector3( x, y, z );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * @return a clone of the internal vector
	 */
	public function getVector():Vector3
	{
		return this.value.clone();
	}
	
	/**
	 * calls setComponents with the values of the given vector
	 */
	public function setVector( vector:Vector3 ):Void
	{
		this.setComponents( vector.x, vector.y, vector.z );
	}
	
	/**
	 * Sets the position to the given coordinates and notifies any listener about a change
	 * 
	 * use this methode when setting multiple values at once in order to avoid multiple event 
	 * broadcasts for the same batch of changes
	 */
	public function setComponents( x:Float, y:Float, z:Float ):Void
	{
		if ( MathUtil.isEqual( this.value.x, x ) 
		&& 	 MathUtil.isEqual( this.value.y, y ) 
		&& 	 MathUtil.isEqual( this.value.z, z ) ) return;
		
		this.value.x = x;
		this.value.y = y;
		this.value.z = z;
		
		this.setDirty();
	}	

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	// x
	private function get_x():Float { return this.value.x; }
	
	private function set_x( x:Float ):Float
	{
		if ( !MathUtil.isEqual( this.value.x, x ) ) 
		{
			this.value.x = x;
			this.setDirty( "x" );
		}		
		
		return x;
	}
	
	// y
	private function get_y():Float { return this.value.y; }
	
	private function set_y( y:Float ):Float
	{
		if ( !MathUtil.isEqual( this.value.y, y ) ) 
		{
			this.value.y = y;
			this.setDirty( "y" );	
		}
		
		return y;
	}
	
	// z
	private function get_z():Float { return this.value.z; }
	
	private function set_z( z:Float ):Float
	{
		if ( !MathUtil.isEqual( this.value.z, z ) ) 
		{
			this.value.z = z;
			this.setDirty( "z" );	
		}	
		
		return z;
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	inline private function setDirty( ?propertyID:String ):Void 
	{		
		if( this.hasEventListener( EvaluateEvent.CHANGED ) )
			this.dispatchEvent( new EvaluateEvent( EvaluateEvent.CHANGED, propertyID ) );
	}	
	
	/**
	 * 
	 * @return
	 */
	override public function toString():String
	{
		return this.value.toString();
	}
	
}