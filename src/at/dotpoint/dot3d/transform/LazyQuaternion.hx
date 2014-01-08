package at.dotpoint.dot3d.transform;

import at.dotpoint.core.event.event.EvaluateEvent;
import at.dotpoint.math.MathUtil;
import at.dotpoint.math.vector.Quaternion;
import flash.events.EventDispatcher;
import flash.events.Event;

/**
 * Manages a Vector and notifies any listener about changes
 * @author Gerald Hattensauer
 */
class LazyQuaternion extends EventDispatcher
{

	private var value:Quaternion;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var z(get, set):Float;
	public var w(get, set):Float;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1 ) 
	{
		super();
		this.value = new Quaternion( x, y, z, w );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //	
	
	/**
	 * @return a clone of the internal vector
	 */
	public function getQuaternion():Quaternion
	{
		return this.value.clone();
	}
	
	/**
	 * calls setComponents with the values of the given vector
	 */
	public function setQuaternion( quaternion:Quaternion ):Void
	{
		this.setComponents( quaternion.x, quaternion.y, quaternion.z, quaternion.w );
	}
	
	/**
	 * Sets the position to the given coordinates and notifies any listener about a change
	 */
	public function setComponents( x:Float, y:Float, z:Float, w:Float ):Void
	{
		if ( MathUtil.isEqual( this.value.x, x ) 
		&& 	 MathUtil.isEqual( this.value.y, y ) 
		&& 	 MathUtil.isEqual( this.value.z, z ) 
		&& 	 MathUtil.isEqual( this.value.w, w ) ) return;
		
		this.value.x = x;
		this.value.y = y;
		this.value.z = z;
		this.value.w = w;
		
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
	
	// w
	private function get_w():Float { return this.value.w; }
	
	private function set_w( w:Float ):Float
	{
		if ( !MathUtil.isEqual( this.value.w, w ) ) 
		{
			this.value.w = w;
			this.setDirty( "w" );	
		}	
		
		return w;
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