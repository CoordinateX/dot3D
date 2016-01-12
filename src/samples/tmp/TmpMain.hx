package;

import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.display.renderable.DisplayObject;
import haxe.at.dotpoint.display.renderable.Renderable;
import haxe.at.dotpoint.dot3d.controls.TransformInputControl;
import haxe.at.dotpoint.dot3d.renderable.input.DefaultRenderInput;
import haxe.at.dotpoint.dot3d.renderable.material.DiffuseColorMaterial;
import haxe.at.dotpoint.dot3d.renderable.mesh.CubeMesh;
import haxe.at.dotpoint.dot3d.renderable.shader.DefaultShader;
import haxe.at.dotpoint.math.Axis;
import haxe.at.dotpoint.math.geom.Space;
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
class TmpMain extends Simple3DMain
{

	/**
	 *
	 */
	private static var instance:TmpMain;

	/**
	 *
	 */
	private var transformControl:TransformInputControl;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		TmpMain.instance = new TmpMain();
	}

	public function new()
	{
		super();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override private function initScene():Void
	{
		super.initScene();

		// ------------------ //

		var mesh:CubeMesh = new CubeMesh( 0.15, 0.15, 0.15 );
		var mate:DiffuseColorMaterial = new DiffuseColorMaterial();
		var shad:DefaultShader = new DefaultShader();

		for( i in 0...200 )
		{
			var renderable:Renderable = new Renderable( null, null );
				renderable.mesh 	= mesh;
				renderable.material = mate;
				renderable.shader 	= shad;

			var disp:DisplayObject = new DisplayObject( renderable );
				disp.transform.position.x = -2 + Math.random() * 4;
				disp.transform.position.y = -2 + Math.random() * 4;
				disp.transform.position.z = -2 + Math.random() * 4;

			this.addDisplayObjectToScene( disp );
		}
	}

	/**
	 *
	 * @param	event
	 */
	override function onBootstrapperComplete( event:Event ):Void
	{
		this.transformControl = new TransformInputControl( this.inputControlSystem );

		// --------- //

		super.onBootstrapperComplete( event );
	}

	/**
	 *
	 */
	override private function onTick():Void
	{
		this.transformControl.update( this.camera.transform );

		for( obj in this.renderList )
		{
			this.appendRotation( Axis.Y, 0.5 * MathUtil.DEG_RAD, obj.transform );
			this.appendRotation( Axis.X, 0.1 * MathUtil.DEG_RAD, obj.transform );
		}

		// -------------- //

		super.onTick();
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