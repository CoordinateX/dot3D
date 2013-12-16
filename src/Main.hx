package ;

import at.dotpoint.dot3d.DrawHelper;
import at.dotpoint.dot3d.MainDot3D;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Plane;
import at.dotpoint.dot3d.shader.PointShader;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.dot3d.Space;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.Lib;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class Main extends MainDot3D
{
	
	private var loader:DataRequest;	
	private var controller:ModelController;	
	
	private var t:Float;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	static public function main() 
	{		
		Lib.current.addChild( new Main() );
	}	
	
	public function new() 
	{
		super();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	override private function init():Void
	{		
		super.init();
		
		//this.createScene();
		
		this.loadScene();			
		this.scene.camera.getTransform( Space.WorldSpace ).position.z -= 20;
		
		this.controller = new ModelController();
		this.controller.moveSpeed = 0.25;	
		
		this.t = 0;
	}	
	
	/**
	 * 
	 */
	private function loadScene():Void
	{
		this.loader = DataRequest.createFromURL( "assets/cube.obj" );
		this.loader.load( this.onComplete );
	}	
	
	/**
	 * 
	 * @param	event
	 */
	private function onComplete( event:Event ):Void
	{
		var list:Vector<Model> = this.loader.getData();
		
		for( model in list )
		{
			this.scene.modelList.push( model );
			
			model.getTransform( Space.WorldSpace ).rotation.pitch( Math.random() * 2 );
			model.getTransform( Space.WorldSpace ).rotation.roll( Math.random() * 2  );
		}
	}
	
	/**
	 * 
	 * @param	event
	 */
	override private function onRenderInitComplete( event:Event ):Void
	{					
		Lib.current.stage.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );	
	}
	
	// ************************************************************************ //
	// UPDATE
	// ************************************************************************ //
	
	/**
	 * 
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.updateScene();	
		this.updateLight();				
		
		this.renderScene();
	}
	
	/**
	 * 
	 */
	private function updateScene():Void
	{		
		this.controller.update( this.scene.camera );	
		
		for( model in this.scene.modelList )
		{
			model.getTransform( Space.WorldSpace ).rotation.pitch( this.controller.rotateSpeed * 0.5 );
			model.getTransform( Space.WorldSpace ).rotation.roll( this.controller.rotateSpeed * 0.25 );	
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

	private function createScene():Void
	{
		var m0:Model = this.createCube( 5 );	
			m0.getTransform( Space.WorldSpace ).position.z -= 30;
		
		var m1:Model = DrawHelper.createAxis( 5 ); 		
			m1.getTransform( Space.WorldSpace ).position.z -= 30;
			m1.getTransform( Space.WorldSpace ).position.x += 0;		
		
		// ----------------- //			
		
		this.scene.modelList.push( m0 );		
	//	this.scene.modelList.push( m1 );
	}
	
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
		
		var mesh:Mesh = new Cube( w, h, l );
		
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
		
		var mesh:Mesh = new Plane( w, h );
		
		var shader:PointShader = new PointShader();
			shader.diffuseColor = new Vector3( 0.25, 1, 0.25 );		
		
		return new Model( mesh, shader ); 
	}
	
}