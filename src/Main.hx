package;

import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.DrawHelper;
import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.dot3d.loader.format.WavefrontMaterialFormat;
import at.dotpoint.dot3d.loader.format.WavefrontObjectFormat;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Plane;
import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.scene.Scene;
import at.dotpoint.dot3d.shader.PointShader;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.dot3d.Space;
import at.dotpoint.loader.DataHelper;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.math.vector.Vector3;
import at.dotpoint.core.event.Event;
import flash.display.Stage3D;
import flash.Lib;
import haxe.ds.Vector;

/**
 * ...
 * @author RK
 */
class Main extends flash.display.Sprite
{
	
	private var renderer:RenderProcessor;
	private var scene:Scene;	
	
	private var loader:DataRequest;	
	
	private var controller:ModelController;	
	private var rotateList:Array<Model>;
	
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
		this.init();
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	private function superInit():Void
	{
		DataHelper.instance.formats.push( WavefrontObjectFormat.instance );
		DataHelper.instance.formats.push( WavefrontMaterialFormat.instance );
		DataHelper.instance.formats.push( TextureFormat.instance );
		
		// --------------------------- //
		
		var stage:Stage3D = Lib.current.stage.stage3Ds[0];
		
		var viewport:Viewport = new Viewport( stage, 800, 600 );		
		
		this.renderer = new RenderProcessor( viewport );
		this.renderer.init( this.onRenderInitComplete );
		
		this.scene = new Scene();
		this.scene.camera = Camera.createDefault( viewport );		
	}
	
	/**
	 * 
	 */
	private function init():Void
	{		
		this.superInit();
		
		this.createScene();		
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
		this.loader.load( this.onComplete );
		trace("never done?");
	}	
	
	/**
	 * 
	 * @param	event
	 */
	private function onComplete( event:Event ):Void
	{trace("nah its done");
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
	
	/**
	 * 
	 * @param	event
	 */
	private function onRenderInitComplete( event:Event ):Void
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
	private function renderScene():Void
	{
		this.renderer.render( this.scene.gatherRenderUnits() );
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

	private function createScene():Void
	{
		var m0:Model = DrawHelper.drawGrid( 100 );	
		
		// ----------------- //			
		
		//this.scene.modelList.push( m0 );		
		this.scene.modelList.push( m0 );
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