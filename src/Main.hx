package;

import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.display.components.transform.Transform;
import flash.display.BitmapData;
import at.dotpoint.dot3d.primitives.Plane;
import flash.display.Bitmap;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicGrid;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicCell;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicSettings;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicSphere.GeodesicSphereMesh;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.model.mesh.editable.CustomMesh;
import at.dotpoint.dot3d.model.mesh.editable.MeshVertex;
import at.dotpoint.core.dispatcher.event.Event;
import at.dotpoint.display.DisplayObjectContainer;
import at.dotpoint.dot3D.bootstrapper.Bootstrapper3D;
import at.dotpoint.dot3d.bootstrapper.InitializeRenderSystemTask;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Line;
import at.dotpoint.dot3d.shader.LineShader;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.Vector3;
/**
 * ...
 * @author RK
 */
class Main extends Bootstrapper3D
{
	
	private static var instance:Main;
	
	// --------------- //
	// Update

	private var controller:ModelController;	
	private var rotateList:Array<DisplayObject>;
	private var lookAtList:Array<DisplayObject>;

	private var t:Float;
	
	// --------------- //

	private var loader:DataRequest;
	private var texture:Texture;

	// --------------- //

	private var container:ModelContainer;

	private var geodesicMesh:GeodesicSphereMesh;
	private var geodesicModel:Model;
	private var geodesicGrid:GeodesicGrid;

	private var initSteps:Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	static public function main() 
	{                
		Main.instance = new Main();
	}        
	
	public function new() 
	{
		super();

		this.processor.taskList.push( new InitializeRenderSystemTask( this ) );
		this.start();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	override function initialize():Void
	{		
		super.initialize();

		// ------------ //

		this.loader = DataRequest.createFromURL( "../assets/textures/grid.jpg", TextureFormat.instance );
		this.loader.load( this.onTexture );

		// ------------ //

		this.initSteps = 0;

		this.scene.camera.getTransform( Space.WORLD ).position.z += 6;
		
		this.controller = new ModelController();
		this.controller.moveSpeed = 0.25;	
		
		this.t = 0;
	}

	/**
	 *
	 * @param	event
	 */
	private function onTexture( event:StatusEvent ):Void
	{
		var bitmap:Bitmap = cast this.loader.result;

		var w:Int = Std.int( bitmap.width );
		var h:Int = Std.int( bitmap.height );

		this.texture = new Texture("texture", w, h );
		this.texture.bitmaps.push( bitmap.bitmapData );
	}
	
	/**
	 * 
	 * @param	event
	 */
	override public function onEnterFrame( event:Event ):Void
	{
		if( this.initSteps != -1 )
		{
			this.initializeScene();
			return;
		}

		this.updateScene();	
		this.updateLight();				
		
		super.onEnterFrame( event );
	}

	// ************************************************************************ //
	// CreateSphere
	// ************************************************************************ //

	/**
	 *
	 */
	private function initializeScene():Void
	{
		if( this.texture == null )
			return;

		switch( this.initSteps )
		{
			case 0: this.createIcosahedron();
			case 1: this.createGeodesicMesh();
			case 2: this.createGeodesicModel();
			case 3: this.createGeodesicGrid();
			case 4: this.drawDebugInformation();
			case 5: this.precalculateGrid();

			default:
			{
				this.initSteps = -1;
				return;
			}
		}

		this.initSteps++;
	}

	/**
	 *
	 */
	private function createIcosahedron():Void
	{
		this.geodesicMesh = new GeodesicSphereMesh( GeodesicSettings.CELLS_12, false );
	}

	/**
	 *
	 */
	private function createGeodesicMesh():Void
	{
		this.geodesicMesh.generateGeodesic();
	}

	/**
	 *
	 */
	private function createGeodesicModel():Void
	{
		var shader:TestShader = new TestShader();
			shader.diffuseMap = this.texture;

		this.geodesicModel = new Model( this.geodesicMesh.buildMesh() );
		this.geodesicModel.material = cast shader;

		this.container = new ModelContainer();
		this.container.addChild( this.geodesicModel );

		this.scene.modelList.push( this.geodesicModel );

		// --------------- //

		this.rotateList = new Array<DisplayObject>();
		this.rotateList.push( this.container );
	}

	/**
	 *
	 */
	private function createGeodesicGrid():Void
	{
		this.geodesicGrid = new GeodesicGrid( this.geodesicMesh );
	}

	/**
	 *
	 */
	private function precalculateGrid():Void
	{
		this.geodesicGrid.precalculate();
	}

	// ************************************************************************ //
	// UPDATE
	// ************************************************************************ //

	/**
	 * 
	 */
	private function updateScene():Void
	{		
		this.controller.update( this.scene.camera );	
		
		if( this.rotateList != null )
		{
			for( model in this.rotateList )
			{
				//model.getTransform( Space.LOCAL ).rotation.yaw( this.controller.rotateSpeed * 1.85 );
			}
		}

		if( this.lookAtList != null )
		{

		}
	}
	
	/**
	 * 
	 */
	private function updateLight():Void
	{
		this.t += 0.0001;	
		
		this.scene.light = new Vector3( Math.cos(t * 10) * 1, Math.sin(t * 5) * 2, Math.sin(t) * Math.cos(t) * 2);
		this.scene.light.normalize();
	}
	
	// ************************************************************************ //
	// drawDebug
	// ************************************************************************ //

	/**
	 *
	 */
	private function drawDebugInformation():Void
	{
		var normals:Model   = this.drawNormals( this.geodesicMesh, 0.05 );
		var cells:Model     = this.drawCells( this.geodesicMesh );

		this.container.addChild( normals );
		this.container.addChild( cells );

		this.scene.modelList.push( normals );
		this.scene.modelList.push( cells );

		this.drawLabels( this.geodesicMesh );
	}

	/**
	 *
	 */
	private function drawCells( mesh:GeodesicSphereMesh ):Model
	{
		var line:Line = new Line();

		var cells:Array<GeodesicCell> = mesh.cells;
		var color:Vector3 = new Vector3( 0, 1, 0 );

		for( cell in cells )
		{
			for( j in 0...cell.corners.length )
			{
				var p1:Vector3 = cell.corners[(j + 0) % cell.corners.length];
				var p2:Vector3 = cell.corners[(j + 1) % cell.corners.length];

				line.moveToVector( p1, color );
				line.lineToVector( p2, color );
			}
		}

		var shader:LineShader = new LineShader();
			shader.thickness = 0.25;

		var model:Model = new Model( line.buildMesh() );
			model.material = cast shader;

		return model;
	}

	/**
	 *
	 */
	private function drawNormals( mesh:CustomMesh, scale:Float ):Model
	{
		var line:Line = new Line();

		var vertices:Array<MeshVertex> = mesh.getVertexList();
		var color:Vector3 = new Vector3( 1, 0, 0 );

		for( vertex in vertices )
		{
			line.moveToVector( vertex.position, color );
			line.lineToVector( Vector3.add( vertex.position, Vector3.scale( vertex.normal, scale ) ), color );
		}

		var shader:LineShader = new LineShader();
			shader.thickness = 0.25;

		var model:Model = new Model( line.buildMesh() );
			model.material = cast shader;

		return model;
	}

	/**
	 *
	 */
	private function drawLabels( mesh:GeodesicSphereMesh ):Void
	{
		var shader:TestShader = new TestShader();
			shader.diffuseMap = this.texture;

		var model:Model = new Plane( 0.5, 0.5 );
			model.material = cast shader;

		model.getTransform( Space.LOCAL ).x += 1;

		// ------------ //

		this.lookAtList = new Array<DisplayObject>();
		this.lookAtList.push( model );

		this.scene.modelList.push( model );
	}

}

class ModelContainer extends DisplayObjectContainer
{
	public function new()
	{
		super();
	}
}