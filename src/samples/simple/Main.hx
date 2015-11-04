package;

import flash.events.Event;
import flash.Lib;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.display.renderable.bitmap.Bitmap;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.renderable.text.TextField;
import haxe.at.dotpoint.dot2d.Stage2DEngine;
import haxe.at.dotpoint.dot3d.camera.PerspectiveLens;
import haxe.at.dotpoint.dot3d.camera.Stage3DCamera;
import haxe.at.dotpoint.dot3d.primitives.AxisTrident;
import haxe.at.dotpoint.dot3d.primitives.Cube;
import haxe.at.dotpoint.dot3d.primitives.Frustum;
import haxe.at.dotpoint.dot3d.primitives.Plane;
import haxe.at.dotpoint.dot3d.renderable.Shape;
import haxe.at.dotpoint.dot3d.scene.Stage3DScene;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.at.dotpoint.loader.DataRequest;
import haxe.at.dotpoint.math.MathUtil;
import haxe.at.dotpoint.math.vector.IQuaternion;
import haxe.at.dotpoint.math.vector.IVector3;
import haxe.at.dotpoint.math.vector.Quaternion;
import haxe.at.dotpoint.math.vector.Vector3;
import flash.ModelController;

/**
 * ...
 * @author RK
 */
class Main
{

	private static var instance:Main;

	// ---------------- //

	private var counter:Int;

	/**
	 *
	 */
	private var loader:DataRequest;

	/**
	 *
	 */
	private var controller:ModelController;

	/**
	 *
	 */
	private var camera:Stage3DCamera;

	/**
	 *
	 */
	private var cubes:Array<IDisplayObject>;

	/**
	 *
	 */
	private var trident:AxisTrident;

	/**
	 *
	 */
	private var plane:Plane;

	/**
	 *
	 */
	private var line:Shape;

	/**
	 *
	 */
	private var text:TextField;

	/**
	 *
	 */
	private var bitmap:Bitmap;

	/**
	 *
	 */
	private var frustum:Shape;

	/**
	 *
	 */
	private var worldAxis:Shape;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	static public function main()
	{
		Main.instance = new Main();
	}

	public function new()
	{
		this.loader = DataRequest.createFromURL( "../res/main/textures/cardboard.jpg" );
		this.loader.load( this.onImageComplete );
	}

	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	private function onImageComplete( event:StatusEvent ):Void
	{
		trace( "image complete", this.loader.result );

		this.initialize();
	}

	/**
	 *
	 */
	private function initialize():Void
	{
		Stage2DEngine.instance.initialize( this.onContextComplete );
		Stage3DEngine.instance.initialize( this.onContextComplete );

		this.counter = 0;
	}

	/**
	 *
	 * @param	event
	 */
	private function onContextComplete( event:StatusEvent ):Void
	{
		if( !Stage2DEngine.instance.isInitialized() )	return;
		if( !Stage3DEngine.instance.isInitialized() )	return;

		// ------------------------- //

		this.init2D();
		this.init3D();

		Lib.current.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );
	}

	/**
	 *
	 */
	private function init2D():Void
	{
		/*var scene:Stage2DScene = cast Stage2DEngine.instance.getScene();

		// ------------- //

		this.bitmap = new Bitmap( new BitmapRenderData( null, cast this.loader.result ) );
		this.bitmap.transform.scale.y = 0.5;
		this.bitmap.transform.scale.x = 0.5;
		this.bitmap.transform.position.x = 400;

		this.text = new TextField( new TextRenderData( null, new TextFormat( "Arial" ) ) );
		this.text.text = "some little text making little little what?";
		this.text.transform.position.y += 100;

		this.cube2D = new Cube( 60, 60, 60 );
		this.cube2D.transform.position.x += 100;
		this.cube2D.transform.position.y += 100;

		Stage2DEngine.instance.getScene().getSpatialTree().addChildNode( this.cube2D.getSpatialNode() );
		Stage2DEngine.instance.getScene().getSpatialTree().addChildNode( this.bitmap.getSpatialNode() );
		Stage2DEngine.instance.getScene().getSpatialTree().addChildNode( this.text.getSpatialNode() );*/
	}

	/**
	 *
	 */
	private function init3D():Void
	{
		var scene:Stage3DScene = cast Stage3DEngine.instance.getScene();
			scene.camera = this.camera = new Stage3DCamera( new PerspectiveLens( Stage3DEngine.instance.getContext().getViewport() ) );

		this.camera.transform.position.z += 4;
		this.camera.transform.position.y += 0;
		this.camera.transform.position.x += 0;

		this.controller = new ModelController();

		// --------------- //

		this.cubes = new Array<IDisplayObject>();

		for( j in 0...20 )
		{
			var cube:Cube = new Cube( 0.25, 0.25, 0.25 );
				cube.transform.position.x = -4 + Math.random() * 8;
				cube.transform.position.y = -4 + Math.random() * 8;
				cube.transform.position.z = -4 + Math.random() * 8;

			//this.cubes.push( cube );

			Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( cube.getSpatialNode() );
		}

		this.line = new Shape();
		this.line.moveTo( [0,0,0], [1,0,0] );

		for( k in 0...240 )
		{
			var x:Float = Math.sin( k / 10 ) * (2 - 1.5 * (k/240) );
			var y:Float = Math.cos( k / 10 ) * (2 - 1.5 * (k / 240) );
			var z:Float = (k / 120) * 2;

			this.line.lineTo( [x,z,y], [1,0,0] );
		}

		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( line.getSpatialNode() );
		this.cubes.push( this.line );

		// --------------- //

		var wal:Float = 10;
		var wac:Array<Float> = [0.2, 0.2, 0.2];

		this.worldAxis = new Shape();
		this.worldAxis.moveTo( [ -wal, 0, 0], wac );
		this.worldAxis.lineTo( [  wal, 0, 0], wac );
		this.worldAxis.moveTo( [ 0, -wal, 0], wac );
		this.worldAxis.lineTo( [ 0,  wal, 0], wac );
		this.worldAxis.moveTo( [ 0, 0, -wal], wac );
		this.worldAxis.lineTo( [ 0, 0,  wal], wac );

		// --------------- //

		var worldTrident:AxisTrident = new AxisTrident( 10, 0.025 );
		var cameraTrident:AxisTrident = new AxisTrident();

		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( worldTrident.getSpatialNode() );
		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( cameraTrident.getSpatialNode() );
		Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( this.worldAxis.getSpatialNode() );

		this.cubes.push( worldTrident );
		this.cubes.push( this.worldAxis );
		//this.cubes.push( cameraTrident );

		this.trident = cameraTrident;
	}


	/**
	 *
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.controller.update( this.camera.transform );
		//this.controller.update( this.line.transform );

		//this.trident.transform.setMatrix( this.camera.transform.getMatrix( Space.WORLD ), Space.WORLD );
		this.trident.transform.rotation = this.lookAt( this.trident.transform.position, this.camera.transform.position );

		this.renderFrustum();

		//Stage2DEngine.instance.getRenderer().render( [this.cube2D,this.text,this.bitmap] );
		Stage3DEngine.instance.getRenderer().render( this.cubes );

	}

	/**
	 *
	 */
	private function renderFrustum():Void
	{
		if( this.frustum == null )
		{
			this.frustum = new Frustum( this.camera.getCamera().getCameraLens() );

			// -------------- //

			this.cubes.push( this.frustum );

			Stage3DEngine.instance.getScene().getSpatialTree().addChildNode( this.frustum.getSpatialNode() );
		}
	}

	/**
	 * @param	source
	 * @param	destination
	 * @return
	 */
	private function lookAt( source:IVector3, destination:IVector3 ):IQuaternion
	{
		var direction:Vector3 = Vector3.subtract( destination, source );
			direction.normalize();

		var dot:Float = Vector3.dot( new Vector3( 0, 0, 1 ), direction );

		// --------------- //

		if( Math.abs( dot + 1 ) < MathUtil.ZERO_TOLERANCE )
			return new Quaternion( 0, 1, 0, 3.1415926535897932 );

		if( Math.abs( dot - 1 ) < MathUtil.ZERO_TOLERANCE )
			return new Quaternion();

		// --------------- //

		var radian:Float = Math.acos( dot );

		var axis:Vector3 = Vector3.cross( new Vector3( 0, 0, 1 ), direction );
			axis.normalize();

		return Quaternion.setAxisAngle( axis, radian );
	}
}

