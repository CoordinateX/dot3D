package;

import at.dotpoint.core.event.Event;
import at.dotpoint.display.components.bounds.BoundingBox;
import at.dotpoint.display.DisplayObjectContainer;
import at.dotpoint.display.Sprite;
import at.dotpoint.dot3D.bootstrapper.Bootstrapper3D;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Line;
import at.dotpoint.dot3d.primitives.Plane;
import at.dotpoint.dot3d.shader.LineShader;
import at.dotpoint.dot3d.shader.PointShader;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.math.geom.Space;
import at.dotpoint.loader.DataRequest;
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
		
		this.loadScene();
		
		this.scene.camera.getTransform( Space.WORLD ).position.z -= 20;
		
		this.controller = new ModelController();
		this.controller.moveSpeed = 0.25;	
		
		this.t = 0;
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
		var list:Vector<Model> = this.loader.result;
		
		this.rotateList = new Array<Model>();
		
		//this.container = new DisplayObjectContainer();		
		
		for( model in list )
		{
			this.scene.modelList.push( model );
			this.rotateList.push( model );
			
			var pitch:Float = Math.random() * 2;			
			var roll:Float 	= Math.random() * 2;
			var yaw:Float 	= Math.random() * 2;
			
			//var pitch:Float = 0;
			//var roll:Float = 0;
			
			model.getTransform( Space.WORLD ).rotation.pitch( pitch );
			model.getTransform( Space.WORLD ).rotation.roll( roll  );	
			//model.getTransform( Space.WORLD ).rotation.yaw( yaw  );	
			
			this.container.addChild( model );
			
			// ----------- // 
			
			var bounds:Model = new Model( this.drawBoundings( model.boundings.modelSpace ), new LineShader() );
				bounds.getTransform( Space.WORLD ).rotation.pitch( pitch );
				bounds.getTransform( Space.WORLD ).rotation.roll( roll );
			
			this.scene.modelList.push( bounds );
			this.rotateList.push( bounds );	
		}
		
		//trace("CONTAINER");
		//this.containerModel = new Model( this.drawBoundings( container.boundings.modelSpace ), new LineShader() );
		//this.scene.modelList.push( this.containerModel );
	}
	
	private var containerModel:Model;
	private var container:DisplayObjectContainer;
	
	// ************************************************************************ //
	// UPDATE
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	event
	 */
	override private function onEnterFrame( event:Event ):Void
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
			model.getTransform( Space.WORLD ).rotation.pitch( this.controller.rotateSpeed * 0.05 );
			model.getTransform( Space.WORLD ).rotation.roll( this.controller.rotateSpeed * 0.025 );	
		}		
		
		//this.containerModel.mesh = this.drawBoundings( this.container.boundings.localSpace );
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
		var w:Float = 1 * scale;
		var h:Float = 1 * scale;
		var l:Float = 1 * scale;
		
		var mesh:Mesh = new CubeMesh( w, h, l );
		
		var shader:TestShader = new TestShader();
			shader.diffuseColor = new Vector3( 1, 0.5, 0.5 );		
		
		return new Model( mesh, shader ); 
	}
	
	/**
	 * 
	 * @param	scale
	 * @return
	 */
	private function createPlane( scale:Float = 1. ):Model
	{
		var w:Float = 1 * scale;
		var h:Float = 1 * scale;
		
		var mesh:Mesh = new PlaneMesh( w, h );
		
		var shader:PointShader = new PointShader();
			shader.diffuseColor = new Vector3( 0.25, 1, 0.25 );		
		
		return new Model( mesh, shader ); 
	}
	
	// ************************************************************************ //
	// Boundings
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	bounds
	 * @return
	 */
	private function drawBoundings( bounds:BoundingBox ):Mesh
	{
		var color:Array<Float> = [1, 0, 0];
		
		var front:Float = bounds.front;
		var back:Float = bounds.back;
		
		var line:Line = new Line( 12, 6 );
			line.moveTo( [bounds.left, 	bounds.top, 	front], color ); 
			line.lineTo( [bounds.right, bounds.top, 	front], color ); 
			line.lineTo( [bounds.right, bounds.bottom, 	front], color ); 
			line.lineTo( [bounds.left, 	bounds.bottom, 	front], color ); 
			line.lineTo( [bounds.left, 	bounds.top, 	front], color ); 
			
			line.moveTo( [bounds.left, 	bounds.top, 	back], 	color ); 
			line.lineTo( [bounds.right, bounds.top, 	back], 	color ); 
			line.lineTo( [bounds.right, bounds.bottom, 	back], 	color ); 
			line.lineTo( [bounds.left, 	bounds.bottom, 	back], 	color ); 
			line.lineTo( [bounds.left, 	bounds.top, 	back], 	color ); 
			
			line.moveTo( [bounds.left, 	bounds.top, 	front], color ); 
			line.lineTo( [bounds.left, 	bounds.top, 	back], 	color );
			
			line.moveTo( [bounds.right, bounds.top, 	front], color ); 
			line.lineTo( [bounds.right, bounds.top, 	back], 	color );
			
			line.moveTo( [bounds.left, 	bounds.bottom, 	front], color ); 
			line.lineTo( [bounds.left, 	bounds.bottom, 	back], 	color );
			
			line.moveTo( [bounds.right, bounds.bottom, 	front], color ); 
			line.lineTo( [bounds.right, bounds.bottom, 	back], 	color );
		
		return line;
	}
}

