package;

import at.dotpoint.dot3d.primitives.geodesic.GeodesicCell;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicSettings;
import at.dotpoint.dot3d.primitives.geodesic.GeodesicSphere.GeodesicSphereMesh;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.model.mesh.editable.CustomMesh;
import at.dotpoint.dot3d.model.mesh.editable.MeshVertex;
import at.dotpoint.dot3d.primitives.icosahedron.IcosahedronSettings;
import at.dotpoint.dot3d.primitives.icosahedron.Icosahedron;
import at.dotpoint.core.dispatcher.event.Event;
import at.dotpoint.display.components.bounds.AABB;
import at.dotpoint.display.DisplayObjectContainer;
import at.dotpoint.dot3D.bootstrapper.Bootstrapper3D;
import at.dotpoint.dot3d.bootstrapper.InitializeRenderSystemTask;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Line;
import at.dotpoint.dot3d.shader.LineShader;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.math.geom.Space;
import at.dotpoint.math.vector.Vector3;
import haxe.ds.Vector;
/**
 * ...
 * @author RK
 */
class Main extends Bootstrapper3D
{
	
	private static var instance:Main;
	
	// --------------- //
	
	private var loader:DataRequest;	
	
	private var controller:ModelController;	
	private var rotateList:Array<Model>;
	
	private var t:Float;
	
	// --------------- //
	
	private var container:ModelContainer;
	private var containerModel:Model;
	
	private var debugList:Array<Model>;
	private var cubeList:Array<Model>;
	
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
		//this.startURL( "config.json" );
		
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

		//this.loadScene();
		this.addIcosahedron();

		this.scene.camera.getTransform( Space.WORLD ).position.z += 6;
		
		this.controller = new ModelController();
		this.controller.moveSpeed = 0.25;	
		
		this.t = 0;
	}

	/**
	 *
	 */
	private function addIcosahedron():Void
	{
		var mesh:GeodesicSphereMesh = new GeodesicSphereMesh( GeodesicSettings.CELLS_42 );

		var sphere:Model = new Model( mesh.buildMesh() );
			sphere.material = cast new TestShader();

		var normals:Model = this.drawNormals( mesh, 0.25 );
		var cells:Model = this.drawCells( mesh );

		this.scene.modelList.push( sphere );
		this.scene.modelList.push( normals );
		this.scene.modelList.push( cells );
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
			for( j in 0...cell.vertices.length )
			{
				var p1:Vector3 = cell.vertices[(j + 0) % cell.vertices.length];
				var p2:Vector3 = cell.vertices[(j + 1) % cell.vertices.length];

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
	private function loadScene():Void
	{
		this.loader = DataRequest.createFromURL( "../assets/cube_staple.obj" );
		this.loader.load( this.onSceneComplete );
	}	
	
	/**
	 * 
	 * @param	event
	 */
	private function onSceneComplete( event:Event ):Void
	{
		trace("onSceneComplete");
		
		var list:Vector<Model> = this.loader.result;
		
		this.rotateList = new Array<Model>();
		this.cubeList 	= new Array<Model>();
		this.debugList 	= new Array<Model>();
		
		this.container = new ModelContainer();		
		
		for( model in list )
		{
			this.scene.modelList.push( model );
			this.rotateList.push( model );
			
			this.cubeList.push( model );
			
			var pitch:Float = Math.random() * 2;			
			var roll:Float 	= Math.random() * 2;
			var yaw:Float 	= Math.random() * 2;
			
			//model.getTransform( Space.WORLD ).rotation.pitch( pitch );
			//model.getTransform( Space.WORLD ).rotation.roll( roll  );	
			//model.getTransform( Space.WORLD ).rotation.yaw( yaw  );	
			
			this.container.addChild( model );
			
			// ----------- // 
			
			var bounds:Model = new Model( this.drawBoundings( model.boundings.worldSpace ), cast new LineShader() );
			
			this.scene.modelList.push( bounds );			
			this.debugList.push( bounds );			
		}
		
		this.containerModel = new Model( this.drawBoundings( this.container.boundings.worldSpace ), cast new LineShader() );		
		this.scene.modelList.push( this.containerModel );		
	}	
	
	// ************************************************************************ //
	// UPDATE
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	event
	 */
	override public function onEnterFrame( event:Event ):Void
	{
		this.updateScene();	
		this.updateLight();				
		
		super.onEnterFrame( event );
	}
	
	/**
	 * 
	 */
	private function updateScene():Void
	{		
		this.controller.update( this.scene.camera );	
		
		if( this.rotateList == null )
			return;
		
		for( model in this.rotateList)
		{
			model.getTransform( Space.WORLD ).rotation.pitch( this.controller.rotateSpeed * 0.5 );
			//model.getTransform( Space.WORLD ).rotation.roll( this.controller.rotateSpeed * 0.25 );	
		}		
		
		this.containerModel.mesh = this.drawBoundings( this.container.boundings.worldSpace );
		
		for( j in 0...this.debugList.length )
		{
			var cube:Model = this.cubeList[j];
			var debug:Model = this.debugList[j];
			
			debug.mesh = this.drawBoundings( cube.boundings.worldSpace );
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
	// Create
	// ************************************************************************ //

	/**
	 * 
	 * @param	scale
	 * @return
	 */
	private function createCube( scale:Float = 1. ):Model
	{
		var shader:TestShader = new TestShader();
			shader.diffuseColor = new Vector3( 1, 0.5, 0.5 );

		var w:Float = 1 * scale;
		var h:Float = 1 * scale;
		var l:Float = 1 * scale;
		
		var model:Cube = new Cube( w, h, l );
			model.material = cast shader;
		
		return model;
	}

	
	// ************************************************************************ //
	// Boundings
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	bounds
	 * @return
	 */
	private function drawBoundings( bounds:AABB ):Mesh
	{
		var color:Array<Float> = [1, 0, 0];
		
		var front:Float = bounds.min.z;
		var back:Float  = bounds.max.z;
		
		var left:Float  = bounds.min.x;
		var right:Float = bounds.max.x;
		
		var top:Float    = bounds.min.y;
		var bottom:Float = bounds.max.y;
		
		// ------------- //
		
		var line:Line = new Line();
			line.moveTo( [left, 	top, 		front], color ); 
			line.lineTo( [right, 	top, 		front], color ); 
			line.lineTo( [right, 	bottom, 	front], color ); 
			line.lineTo( [left, 	bottom, 	front], color ); 
			line.lineTo( [left, 	top, 		front], color ); 
			
			line.moveTo( [left, 	top, 		back], 	color ); 
			line.lineTo( [right, 	top, 		back], 	color ); 
			line.lineTo( [right, 	bottom, 	back], 	color ); 
			line.lineTo( [left, 	bottom, 	back], 	color ); 
			line.lineTo( [left, 	top, 		back], 	color ); 
			
			line.moveTo( [left, 	top, 		front], color ); 
			line.lineTo( [left, 	top, 		back], 	color );
			
			line.moveTo( [right, 	top, 		front], color ); 
			line.lineTo( [right, 	top, 		back], 	color );
			
			line.moveTo( [left, 	bottom, 	front], color ); 
			line.lineTo( [left, 	bottom, 	back], 	color );
			
			line.moveTo( [right, 	bottom, 	front], color ); 
			line.lineTo( [right, 	bottom, 	back], 	color );
		
		return line.buildMesh();
	}
}

class ModelContainer extends DisplayObjectContainer
{
	public function new()
	{
		super();
	}
}