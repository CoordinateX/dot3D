package at.dotpoint.dot3d.transform;

import at.dotpoint.core.event.EvaluateEvent;
import at.dotpoint.dot3d.transform.LazyQuaternion;
import at.dotpoint.dot3d.transform.LazyVector3;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Quaternion;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * Manages the Rotation using an Euler representation aswell a Quaternion and Matrix representation; 
 * The Quaternion is used for all calculations and generation of the Matrix and it's adviced to keep it that way.
 * Although the Matrix is a 4x4, only the upper left 3x3 is used. (rest might not be ignored though)
 * 
 * @author Gerald Hattensauer
 */
@:access(at.dotpoint.dot3d.transform)
//
class Rotation extends EventDispatcher
{
	
	private var euler:LazyVector3;
	private var invalidEuler:Bool;
	
	private var quaternion:LazyQuaternion;	
	private var invalidQuaternion:Bool;	
	
	private var matrix:Matrix44;	
	private var invalidMatrix:Bool;	
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( x:Float = 0, y:Float = 0, z:Float = 0 ) 
	{
		super();
		
		this.euler 		= new LazyVector3( x, y, z );		
		this.quaternion = new LazyQuaternion();
		this.matrix 	= new Matrix44();
		
		this.init();
	}	
	
	/**
	 * initializes the matrix and quaternion using the euler values from the constructor
	 * after construction, everything is clean and ready to access (quaternion, euler and matrix)
	 */
	private function init():Void
	{
		this.updateQuaternion(); // take euler values and set quaternion
		this.getMatrix();		 // fill matrix with using the quaternion
		
		this.euler.addEventListener( EvaluateEvent.CHANGED, this.onEulerChange, false, 0, true );
		this.quaternion.addEventListener( EvaluateEvent.CHANGED, this.onQuaternionChange, false, 0, true );
	}
	
	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //
	
	/**
	 * euler representation of the rotation; Euler angle computations are not continuous 
	 * and my oscilate between two poles when incrementally altering an axis; use quaternions instead; 
	 * using the given rotation methodes is recommended
	 * 
	 * @return
	 */	
	public function getEuler():LazyVector3 
	{
		if ( this.invalidEuler ) 
			this.updateEuler();
		
		return this.euler;
	}
	
	/**
	 * quaternion representation of the rotation; using the given rotation methodes is recommended
	 * @return
	 */	
	public function getQuaternion():LazyQuaternion 
	{
		if ( this.invalidQuaternion )		
			this.updateQuaternion();
		
		return this.quaternion;
	}	
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	// onChange, matrix invalid, rotation changed
	private function onEulerChange( ?event:Event ):Void 
	{
		this.invalidQuaternion = true;
		this.invalidMatrix = true;
		
		this.setDirty();
	}
	
	// onChange, matrix invalid, rotation changed
	private function onQuaternionChange( ?event:Event ):Void 
	{
		this.invalidEuler = true;
		this.invalidMatrix = true;
		
		this.setDirty();
	}
	
	/**
	 * updates the quaternion representation, using the euler representation; make sure euler is newer
	 * 
	 * e.g: user changes the rotation using euler, but quaternion are used later in some calculations.
	 * the quaternion still has the old rotation and needs to be updated
	 */
	private function updateQuaternion():Void
	{
		Quaternion.setEuler( this.euler.value, this.quaternion.value ); // update using the newer euler values
		this.invalidQuaternion = false;									// set euler as old, quaternion represents it now
	}	
	
	/**
	 * updates the euler representation, using the quaternion representation; make sure quaternion is newer
	 * 
	 * e.g: user changes the rotation using quaternions, but euler are used later in some calculations.
	 * the euler still has the old rotation and needs to be updated
	 */
	private function updateEuler():Void
	{	
		Quaternion.toEuler( this.quaternion.value, this.euler.value );	// update using the newer quaternion values
		this.invalidEuler = false;										// set quaternion as old, euler represents it now
	}
	
	// ___________________________________________________________________________ 
	//															  # user methodes
	
	/**
	 * 
	 * @param	radians
	 */
	public function pitch( radians:Float ):Void 
	{
		this.setAxisAngle( new Vector3( 1, 0, 0 ), radians );
	}
	
	/**
	 * 
	 * @param	radians
	 */
	public function yaw( radians:Float ):Void 
	{
		this.setAxisAngle( new Vector3( 0, 1, 0 ), radians );
	}
	
	/**
	 * 
	 * @param	radians
	 */
	public function roll( radians:Float ):Void 
	{
		this.setAxisAngle(  new Vector3( 0, 0, 1 ), radians );
	}
	
	/**
	 * 
	 * @param	axis
	 * @param	radians
	 */
	public function setAxisAngle( axis:Vector3, radians:Float ):Void
	{
		var rotation:Quaternion = Quaternion.setAxisAngle( axis, radians, new Quaternion() );
		
		var new_rotation:Quaternion = Quaternion.multiply( this.quaternion.value, rotation, new Quaternion() );
			new_rotation.normalize();
		
		this.quaternion.setQuaternion( new_rotation ); // dispatches on change
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	/* INTERFACE at.dotpoint.tilezeit.ITransformComponent */
	
	/**
	 * returns a clone of the internal rotation matrix; updating it in case the quaternion representation has changed
	 * (and updates the quaternion in case the euler representation is the newest)
	 * 
	 * column-matrix 3x3;
	 */
	public function getMatrix( ?output:Matrix44 ):Matrix44
	{			
		if ( this.invalidMatrix )
			this.validate();
		
		output = output != null ? output : new Matrix44();
		output.set44( this.matrix );	
		
		return output;
	}
	
	/**
	 * updates the matrix using its internal quaternion and euler; 
	 */
	private function validate():Void 
	{
		if( this.invalidQuaternion )
			this.updateQuaternion();
			
		Quaternion.toMatrix( this.quaternion.value, this.matrix );		
		this.invalidMatrix = false;
	}
	
	/**
	 * updates the internal state using the given rotation matrix.
	 * this is a relativly costly operation
	 * 
	 * the quaternion is updated immediatly. the euler representation is not and is updated when 
	 * accessed (lazy on getEuler). a clone of the given matrix replaces the internal matrix
	 * 
	 * column-matrix 3x3;
	 */
	public function setMatrix( matrix:Matrix44 ):Void
	{
		if ( !Matrix44.isEqual( this.matrix, matrix ) )
		{
			Quaternion.setMatrix( matrix, this.quaternion.value );		
			this.matrix = new Matrix44( matrix );
			
			this.invalidMatrix 		= false;	
			this.invalidQuaternion 	= false; 
			this.invalidEuler 		= true; // euler still needs to be updated
			
			this.setDirty();
		}
	}
	
	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //
	
	inline private function setDirty( ?propertyID:String ):Void 
	{
		if ( this.invalidEuler && this.invalidQuaternion ) 
			throw "irrecoverable state - euler and quaternion have been invalidated at the same time";
		
		if( this.hasEventListener( EvaluateEvent.CHANGED ) )
			this.dispatchEvent( new EvaluateEvent( EvaluateEvent.CHANGED, propertyID ) );
	}	

}