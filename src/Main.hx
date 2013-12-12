package ;

import at.dotpoint.core.MainApplication;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.camera.OrtographicLens;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.primitives.Line;
import at.dotpoint.dot3d.primitives.Plane;
import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.RenderUnit;
import at.dotpoint.dot3d.render.ScreenDimension;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.Space;
import at.dotpoint.dot3d.transform.Transform;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.Lib;
import shader.LineShader;
import shader.PointShader;
import shader.TestShader;


/**
 * ...
 * @author RK
 */
class Main extends MainApplication
{
	
	private var renderer:RenderProcessor;
	private var controller:ModelController;
	
	private var model:Model;
	private var camera:Camera;
	private var light:Vector3;
	
	private var modelList:Array<Model>;
	
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
		var viewport:Viewport = Viewport.create( this, true );		
		
		this.renderer = new RenderProcessor( viewport );
		this.renderer.init( this.onRenderInitComplete );
		
		this.controller = new ModelController();
		this.controller.moveSpeed = 0.25;
		
		this.t = 0;
	}	
	
	/**
	 * 
	 * @param	event
	 */
	private function onRenderInitComplete( event:Event ):Void
	{
		var ratio:Float = this.renderer.viewport.ratio;
		
		var h:Int = 2;
		var w:Int = Std.int( h * ratio );
		
		var dimension:ScreenDimension = new ScreenDimension( w, h );
		
		//this.camera = Camera.createDefault( this.renderer.viewport );
		this.camera = new Camera( new OrtographicLens(  dimension ) );
		
		// ----------------- //
		
		var m0:Model = this.createCube( 5 ); // this.createCube( 200 );		
			m0.getTransform( Space.WorldSpace ).position.z += 50;
		
		var m1:Model = this.createCube( 5 ); // this.createCube( 200 );		
			m1.getTransform( Space.WorldSpace ).position.x += 0;	
			m1.getTransform( Space.WorldSpace ).position.z -= 18;	
			m1.getTransform( Space.WorldSpace ).position.y -= 8;
			
		var m2:Model = this.createLine(); // this.createCube( 200 );		
			m2.getTransform( Space.WorldSpace ).position.z -= 10;
			m2.getTransform( Space.WorldSpace ).position.x += 8;
		
		var m3:Model = this.createLine(); // this.createCube( 200 );		
			m3.getTransform( Space.WorldSpace ).position.z -= 10;	
			m3.getTransform( Space.WorldSpace ).position.x -= 4;	
			m3.getTransform( Space.WorldSpace ).position.y += 5;	
			m3.getTransform( Space.WorldSpace ).rotation.pitch( 1.5 );
			
		// ----------------- //	
		
		this.modelList = new Array<Model>();
		this.modelList.push( m1 );
		this.modelList.push( m2 );
		this.modelList.push( m3 );		
		//this.modelList.push( m3 );
		
		this.model = m2;
		
		Lib.current.stage.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );	
	}
	
	/**
	 * 
	 * @param	event
	 */
	private function onEnterFrame( event:Event ):Void
	{
		this.controller.update( this.model );
		
		this.updateLight();	
		
		/*if( this.controller.isKeyDown )
			this.updateCamera();*/
		
		//if( !this.controller.isKeyDown )	
		//	this.model.getTransform( Space.WorldSpace ).rotation.pitch( this.controller.rotateSpeed * 0.5 );
			
		this.render();
	}
	
	/**
	 * 
	 */
	private function updateCamera():Void
	{
		var camera:Transform = this.camera.getTransform( Space.WorldSpace );		
		var model:Transform = this.model.getTransform( Space.WorldSpace );
		
		var target:Vector3 = Vector3.subtract( model.position.getVector(), camera.position.getVector() );
			target.x *= 1;
			target.y *= 1;
			target.z *= 1;
			
		model.rotation.lookAt( target );	
		
		trace( camera.position.getVector() );	
		trace( model.rotation );	
			
		/*var sec:Transform = this.modelList[1].getTransform( Space.WorldSpace );
			sec.rotation.lookAt( camera.position.getVector() );	*/
			
		//camera.rotation.lookAt( model.position.getVector() );
	}
	
	/**
	 * 
	 */
	private function updateLight():Void
	{
		this.t += 0.0001;	
		
		this.light = new Vector3( Math.cos(t * 10) * 1, Math.sin(t * 5) * 2, Math.sin(t) * Math.cos(t) * 2);
		this.light.normalize();
	}
	
	// ************************************************************************ //
	// RENDER
	// ************************************************************************ //
	
	/**
	 * 
	 */
	@:access(hxsl.Shader)
//
	private function render():Void
	{
		var unitList:Array<RenderUnit> = new Array<RenderUnit>();
		
		for( model in this.modelList )
		{			
			var m2w:Matrix44 = model.getTransform( Space.WorldSpace ).getMatrix();
			var w2c:Matrix44 = this.camera.getProjectionMatrix();		
			
			var cam:Matrix44 = this.camera.getTransform( Space.WorldSpace ).getMatrix();			
			
			Reflect.setProperty( model.material.shader, Register.MODEL_WORLD.ID, m2w );
			Reflect.setProperty( model.material.shader, Register.WORLD_CAMERA.ID, w2c );
			//Reflect.setProperty( model.material.shader, "light", this.light );
			
			var unit:RenderUnit = new RenderUnit();
				unit.context 	= model.material.contextSetting;
				unit.shader 	= model.material.shader;
				unit.mesh 		= model.mesh;
				
			unitList.push( unit );
		}
	
		this.renderer.render( unitList );
	}
	
	// ************************************************************************ //
	// Create
	// ************************************************************************ //

	private var test:TestShader;
	
	/**
	 * 
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
	
	private function createPlane( scale:Float = 1. ):Model
	{
		var w:Float = 1 * scale;
		var h:Float = 1 * scale;
		
		var mesh:Mesh = new Plane( w, h );
		
		var shader:PointShader = new PointShader();
			shader.diffuseColor = new Vector3( 0.25, 1, 0.25 );		
		
		return new Model( mesh, shader ); 
	}
	
	private function createLine( size:Float = 5., thickness:Float = 1, segments:Int = 5 ):Model
	{
		var mesh:Line = new Line( segments );
		
		// --------------- //	
		
		var current:Vector3 = new Vector3();
		
		var p1:Float = 1;
		var p2:Float = 3;
		var p3:Float = 10;
		
		for( i in 0...segments )
		{
			var t:Float = i / p1;
			
			var s:Float = Math.sin(i * p2 / segments) * size;
			
			current.x = Math.sin( t ) * s;
			current.y = Math.cos( t ) * s;
			current.z = (i / segments) * p3;
			
			mesh.line( current.toArray() );
		}
		
		// --------------- //
		
		var shader:LineShader = new LineShader();
			shader.diffuseColor = new Vector3( 0.25, 0.25, 1 );		
			shader.thickness = thickness;		
		
		var model:Model = new Model( mesh, shader ); 			
			//model.getTransform( Space.WorldSpace ).rotation.yaw( 0.25 );
			//model.getTransform( Space.WorldSpace ).position.y += 5;
			//model.getTransform( Space.WorldSpace ).position.z += 5;
			
		return model;
	}
}