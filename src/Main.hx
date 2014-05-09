package;

import at.dotpoint.core.event.Event;
import at.dotpoint.dot3D.bootstrapper.Bootstrapper3D;
import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.dot3d.loader.format.WavefrontMaterialFormat;
import at.dotpoint.dot3d.loader.format.WavefrontObjectFormat;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Plane;
import at.dotpoint.dot3d.shader.PointShader;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.dot3d.Space;
import at.dotpoint.loader.DataHelper;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.math.vector.Vector3;
import flash.Lib;
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
		this.startURL( "config.json" );
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
		
		DataHelper.instance.formats.push( WavefrontObjectFormat.instance );
		DataHelper.instance.formats.push( WavefrontMaterialFormat.instance );
		DataHelper.instance.formats.push( TextureFormat.instance );			
		
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
		
		for( model in list )
		{
			this.scene.modelList.push( model );
			this.rotateList .push( model );
			
			model.getTransform( Space.WorldSpace ).rotation.pitch( Math.random() * 2 );
			model.getTransform( Space.WorldSpace ).rotation.roll( Math.random() * 2  );			
		}
	}
	
	
	
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