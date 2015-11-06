package;

import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.display.material.DiffuseColorMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.calculations.MeshCalculationTools;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshEditingTools;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshTriangle;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.editing.MeshVertex;
import haxe.at.dotpoint.display.renderable.geometry.mesh.util.SharedVertexPolicy;
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
import haxe.at.dotpoint.math.vector.IMatrix44;
import haxe.at.dotpoint.math.vector.IQuaternion;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Matrix44;
import haxe.at.dotpoint.math.vector.Quaternion;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.at.dotpoint.spatial.transform.ITransform;
import haxe.at.dotpoint.spatial.transform.Transform;
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

	public static var instance:Java3DMain;

	// ---------------- //

	/**
	 *
	 */
	private var keyInputCallback:MyKeyInputCallback;

	/**
	 *
	 */
	public var camera:Stage3DCamera;

	/**
	 *
	 */
	public var test:Sprite;

	/**
	 *
	 */
	public var time:Float;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		Java3DMain.instance = new Java3DMain();
	}

	public function new()
	{
		if( Java3DMain.instance == null )
			Java3DMain.instance = this;

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
		this.time = 0;

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
			scene.light = this.getLight();

		this.camera.transform.position.z -= 40;
		this.camera.transform.position.y += 30;
		this.camera.transform.position.x += 0;

		// --------------- //

		var plane:IMeshData = new PlaneMesh( 200, 200, 60, 60 );

		this.gerstner( plane, 0.5 );

		var shader:ShaderSignature 	= new ShaderSignature( "TestShader", 1 );
		var mesh:IMeshData 			= plane; // new MeshData();
		var material:IMaterial 		= new DiffuseColorMaterial();

		this.test = new Sprite( new ModelRenderData( shader, mesh, material ) );
		this.test.transform.position.z -= 200.8;

		//Quaternion.setAxisAngle( Quaternion.getAxis( this.test.transform.rotation, Axis.X ), 90 * MathUtil.DEG_RAD, this.test.transform.rotation );

		// --------------- //

		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( this.test.getSpatialNode() );
	}

	/**
	 *
	 * @param	plane
	 * @param	time
	 */
	private function gerstner( plane:IMeshData, time:Float, doUpdate:Bool = true ):Void
	{
		var amplitude:Float 	= 2.0;
		var sharpness:Float 	= 1.8;
		var frequency:Float 	= 0.6;
		var wavelength:Float 	= 15.0;

		var direction:Vector3 = new Vector3( 0.3, 0.0, -0.3 );

		//----------------- //

		var vertices:Array<MeshVertex> = MeshEditingTools.getMeshVertexList( plane );

		for( vertex in vertices )
		{
			var scalar:Float = Vector3.dot( direction, vertex.position );

			var k:Float 	= 2 * Math.PI / wavelength;
			var magic:Float = k * scalar - frequency * time;

			var cos:Float = Math.cos( magic );
			var sin:Float = Math.sin( magic );

			// ------------------ //

			var x:Float = vertex.position.x + sharpness * amplitude * direction.x * cos;
			var z:Float = vertex.position.z + sharpness * amplitude * direction.z * cos;
			var y:Float = vertex.position.y + amplitude * sin;

			vertex.position = new Vector3( x, y, z );
		}

		//----------------- //

		if( !doUpdate )
			return;

		MeshEditingTools.setMeshVertexList( plane, vertices );
		MeshCalculationTools.recalculateNormals( plane, SharedVertexPolicy.COMBINE );
	}

	/**
	 *
	 * @return
	 */
	private function getLight():IVector3
	{
		var light:Vector3 = new Vector3( 1.0, 1.0, 0.0, 0 );

		//var rot:Quaternion = Quaternion.setAxisAngle( new Vector3( 0, 1, 1 ), -30 * MathUtil.DEG_RAD );
		//var rotLight:Vector3 = Quaternion.multiplyVector( rot, light );

		//trace( rotLight );

		return light;
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
		this.appendRotation( Axis.Y, 0.1 * MathUtil.DEG_RAD, this.test.transform );
		this.gerstner( this.test.mesh, this.time += 1, false );

		Stage3DEngine.instance.getRenderer().render( [this.test] );
	}

}

/**
 *
 */
class MyKeyInputCallback extends GLFWKeyCallback
{

	private var moveSpeed:Float  = 5;
	private var rotateSpeed:Float = 1 * MathUtil.DEG_RAD;

	/**
	 *
	 */
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

		if( action == GLFW.GLFW_PRESS || action == GLFW.GLFW_REPEAT )
		{
			var transform:ITransform = Java3DMain.instance.camera.transform;

			// ---------------------------- //
			// translation

			if( mods != GLFW.GLFW_MOD_SHIFT )
			{
				if( key == GLFW.GLFW_KEY_W )
					this.appendTranslation( Axis.Z, -this.moveSpeed, transform );

				if( key == GLFW.GLFW_KEY_S )
					this.appendTranslation( Axis.Z,  this.moveSpeed, transform );

				if( key == GLFW.GLFW_KEY_A )
					this.appendTranslation( Axis.X, -this.moveSpeed, transform );

				if( key == GLFW.GLFW_KEY_D )
					this.appendTranslation( Axis.X,  this.moveSpeed, transform );

				if( key == GLFW.GLFW_KEY_R )
					this.appendTranslation( Axis.Y,  this.moveSpeed, transform );

				if(  key == GLFW.GLFW_KEY_F )
					this.appendTranslation( Axis.Y, -this.moveSpeed, transform );
			}

			// ---------------------------- //
			// rotation

			if( mods == GLFW.GLFW_MOD_SHIFT )
			{
				if(  key == GLFW.GLFW_KEY_W )
					this.appendRotation( Axis.X,  this.rotateSpeed, transform );

				if(  key == GLFW.GLFW_KEY_S )
					this.appendRotation( Axis.X, -this.rotateSpeed, transform );

				if(  key == GLFW.GLFW_KEY_A )
					this.appendRotation( Axis.Y, -this.rotateSpeed, transform );

				if(  key == GLFW.GLFW_KEY_D )
					this.appendRotation( Axis.Y,  this.rotateSpeed, transform );

				if(  key == GLFW.GLFW_KEY_R )
					this.appendRotation( Axis.Z,  this.rotateSpeed, transform );

				if(  key == GLFW.GLFW_KEY_F )
					this.appendRotation( Axis.Z, -this.rotateSpeed, transform );
			}

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
		trace("translate", axis, distance, transform );

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
		trace("rotate", axis, radians, transform );

		var origin:IQuaternion = transform.rotation;
		var vector:IVector3 = Quaternion.getAxis( origin, axis );

		var rotation:Quaternion = Quaternion.setAxisAngle( vector, radians, new Quaternion() );
			rotation.normalize();

		var new_rotation:Quaternion = Quaternion.multiply( origin, rotation, new Quaternion() );
			new_rotation.normalize();

		new_rotation.clone( origin );
	}
}