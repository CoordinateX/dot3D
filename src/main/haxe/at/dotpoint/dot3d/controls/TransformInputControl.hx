package haxe.at.dotpoint.dot3d.controls;
import haxe.at.dotpoint.controls.InputControlSystem;
import haxe.at.dotpoint.controls.InputRequest;
import haxe.at.dotpoint.math.Axis;
import haxe.at.dotpoint.math.MathUtil;
import haxe.at.dotpoint.math.vector.IQuaternion;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Quaternion;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.at.dotpoint.spatial.transform.ITransform;

/**
 * ...
 * @author RK
 */
class TransformInputControl
{

	/**
	 *
	 */
	public var speedTranslation:Float = 0.05;

	/**
	 *
	 */
	public var speedRotation:Float = 1 * MathUtil.DEG_RAD;

	// ---------------- //

	//
	public var inputFront:InputRequest;

	//
	public var inputBack:InputRequest;

	//
	public var inputLeft:InputRequest;

	//
	public var inputRight:InputRequest;

	//
	public var inputUp:InputRequest;

	//
	public var inputDown:InputRequest;

	//
	public var inputRotation:InputRequest;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		this.inputFront 	= InputControlSystem.instance.getInputRequest( "forward" );
		this.inputBack 		= InputControlSystem.instance.getInputRequest( "backward" );
		this.inputLeft 		= InputControlSystem.instance.getInputRequest( "left" );
		this.inputRight 	= InputControlSystem.instance.getInputRequest( "right" );
		this.inputUp 		= InputControlSystem.instance.getInputRequest( "up" );
		this.inputDown 		= InputControlSystem.instance.getInputRequest( "down" );
		this.inputRotation 	= InputControlSystem.instance.getInputRequest( "rotation" );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	public function update( transform:ITransform ):Void
	{
		// ---------------------------- //
		// translation

		if ( InputControlSystem.instance.getInputValue( this.inputRotation ) <= 0 )
		{
			if ( InputControlSystem.instance.getInputValue( this.inputFront ) > 0 )
				this.appendTranslation( Axis.Z, -this.speedTranslation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputBack ) > 0 )
				this.appendTranslation( Axis.Z,  this.speedTranslation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputLeft ) > 0 )
				this.appendTranslation( Axis.X, -this.speedTranslation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputRight ) > 0 )
				this.appendTranslation( Axis.X,  this.speedTranslation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputUp ) > 0 )
				this.appendTranslation( Axis.Y,  this.speedTranslation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputDown ) > 0 )
				this.appendTranslation( Axis.Y, -this.speedTranslation, transform );
		}

		// ---------------------------- //
		// rotation

		if ( InputControlSystem.instance.getInputValue( this.inputRotation ) > 0 )
		{
			if ( InputControlSystem.instance.getInputValue( this.inputFront ) > 0 )
				this.appendRotation( Axis.X, -this.speedRotation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputBack ) > 0 )
				this.appendRotation( Axis.X,  this.speedRotation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputLeft ) > 0 )
				this.appendRotation( Axis.Y, -this.speedRotation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputRight ) > 0 )
				this.appendRotation( Axis.Y,  this.speedRotation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputUp ) > 0 )
				this.appendRotation( Axis.Z,  this.speedRotation, transform );

			if ( InputControlSystem.instance.getInputValue( this.inputDown ) > 0 )
				this.appendRotation( Axis.Z, -this.speedRotation, transform );
		}
	}

	/**
	 *
	 * @param	axis
	 * @param	distance
	 * @param	transform
	 */
	private function appendTranslation( axis:Axis, distance:Float, transform:ITransform ):Void
	{
		var origin:IQuaternion = transform.rotation;

		var vector:IVector3 = Quaternion.getAxis( origin, axis );
			vector = Vector3.scale( vector, distance, vector );

		Vector3.add( transform.position, vector, transform.position );
	}

	/**
	 *
	 * @param	axis
	 * @param	radians
	 */
	private function appendRotation( axis:Axis, radians:Float, transform:ITransform ):Void
	{
		var origin:IQuaternion = transform.rotation;
		var vector:IVector3 = Quaternion.getAxis( origin, axis );

		var rotation:Quaternion = Quaternion.setAxisAngle( vector, radians, new Quaternion() );
			rotation.normalize();

		var new_rotation:Quaternion = Quaternion.multiply( origin, rotation, new Quaternion() );
			new_rotation.normalize();

		new_rotation.clone( origin );
	}
}