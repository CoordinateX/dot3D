package;

import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.display.material.DiffuseColorMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.ModelRenderData;
import haxe.at.dotpoint.display.renderable.geometry.Sprite;
import haxe.at.dotpoint.display.rendering.shader.ShaderSignature;
import haxe.at.dotpoint.dot3d.camera.PerspectiveLens;
import haxe.at.dotpoint.dot3d.camera.Stage3DCamera;
import haxe.at.dotpoint.dot3d.primitives.Cube.CubeMesh;
import haxe.at.dotpoint.dot3d.primitives.Plane.PlaneMesh;
import haxe.at.dotpoint.dot3d.scene.Stage3DScene;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.math.Axis;
import haxe.at.dotpoint.math.MathUtil;
import haxe.at.dotpoint.math.vector.IQuaternion;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Quaternion;
import haxe.at.dotpoint.spatial.transform.ITransform;
import haxe.Int64;
import org.lwjgl.glfw.GLFW;
import org.lwjgl.glfw.GLFWvidmode;
import org.lwjgl.glfw.GLFWErrorCallback;
import org.lwjgl.glfw.GLFWKeyCallback;
import org.lwjgl.glfw.Callbacks;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL15;
import org.lwjgl.opengl.GL20;
import org.lwjgl.opengl.GL30;
import org.lwjgl.opengl.GLContext;
import org.lwjgl.BufferUtils;
/**
 * ...
 * @author RK
 */
class Java3DMain
{

	private static var instance:Java3DMain;

	// ---------------- //

	private var keyInputCallback:MyKeyInputCallback;

	/**
	 *
	 */
	private var camera:Stage3DCamera;

	/**
	 *
	 */
	private var test:Sprite;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		Java3DMain.instance = new Java3DMain();
	}

	public function new()
	{
		this.initialize();
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	/**
	 *
	 */
	private function initialize():Void
	{
		//Stage2DEngine.instance.initialize( this.onContextComplete );
		Stage3DEngine.instance.getContext().getViewport().setDimension( 960, 540 );
		Stage3DEngine.instance.initialize( this.onContextComplete );
	}

	/**
	 *
	 * @param	event
	 */
	private function onContextComplete( event:StatusEvent ):Void
	{
		//if( !Stage2DEngine.instance.isInitialized() )	return;
		if( !Stage3DEngine.instance.isInitialized() )	return;

		// ------------------------- //

		//this.init2D();


		 try
		{
			this.init3D();

			var count:Int = 0;

			GLFW.glfwSetKeyCallback( Stage3DEngine.instance.getContext().ptr_window, this.keyInputCallback = new MyKeyInputCallback() );

			while( GLFW.glfwWindowShouldClose( Stage3DEngine.instance.getContext().ptr_window ) == GL11.GL_FALSE )
			{
				//if( count++ == 0 )
					this.onEnterFrame();

				GLFW.glfwPollEvents();
			}
        }
		catch( e:Dynamic )
		{
			throw e; // so we catch java exceptions, yet throw it with a trusty callstack
        }

        Sys.exit(0);

	}

	/**
	 *
	 */
	private function init2D():Void
	{

	}

	/**
	 *
	 */
	private function init3D():Void
	{
		var scene:Stage3DScene = cast Stage3DEngine.instance.getScene();
			scene.camera = this.camera = new Stage3DCamera( new PerspectiveLens( Stage3DEngine.instance.getContext().getViewport() ) );

		this.camera.transform.position.z += 0;
		this.camera.transform.position.y += 0;
		this.camera.transform.position.x += 0;

		// --------------- //

		var shader:ShaderSignature 	= new ShaderSignature( "TestShader", 1 );
		var mesh:IMeshData 			= new CubeMesh( 100.5, 100.5 , 100.5 );
		var material:IMaterial 		= new DiffuseColorMaterial();

		this.test = new Sprite( new ModelRenderData( shader, mesh, material ) );
		//this.test.transform.position.x -= 0.4;
		//this.test.transform.position.y -= 0.2;
		this.test.transform.position.z -= 200.8;

		// --------------- //

		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( this.test.getSpatialNode() );
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


	/**
	 *
	 * @param	event
	 */
	private function onEnterFrame():Void
	{
		this.appendRotation( Axis.X, 1 * MathUtil.DEG_RAD, this.test.transform );
		this.appendRotation( Axis.Y, 1 * MathUtil.DEG_RAD, this.test.transform );

		Stage3DEngine.instance.getRenderer().render( [this.test] );
	}

}

/**
 *
 */
class MyKeyInputCallback extends GLFWKeyCallback
{
	public function new()
	{
		super();
	}

	/**
	 *
	 * @param	code
	 * @param	ptr_description
	 */
	@:overload
	//
	override public function invoke( window:Int64, key:Int, scancode:Int, action:Int, mods:Int )
	{
		if ( key == GLFW.GLFW_KEY_ESCAPE && action == GLFW.GLFW_RELEASE )
		{
			GLFW.glfwSetWindowShouldClose( window, GL11.GL_TRUE ); // We will detect this in our rendering loop
		}
	}
}