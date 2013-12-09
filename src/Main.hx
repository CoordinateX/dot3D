package ;

import at.dotpoint.core.MainApplication;
import at.dotpoint.dot3d.camera.Camera;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.primitives.Cube;
import at.dotpoint.dot3d.render.RenderProcessor;
import at.dotpoint.dot3d.render.RenderUnit;
import at.dotpoint.dot3d.render.Viewport;
import at.dotpoint.dot3d.Space;
import at.dotpoint.math.vector.Matrix44;
import at.dotpoint.math.vector.Vector3;
import flash.events.Event;
import flash.Lib;


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
		this.controller.moveSpeed = 10;
		
		this.t = 0;
	}	
	
	/**
	 * 
	 * @param	event
	 */
	private function onRenderInitComplete( event:Event ):Void
	{
		this.camera = Camera.createDefault( this.renderer.viewport );
		
		this.model = this.createCube( 200 );		
		this.model.getTransform( Space.WorldSpace ).position.z += 800;
		
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
		
		this.render();
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
	
	/**
	 * 
	 */
	private function render():Void
	{
		var m2w:Matrix44 = this.model.getTransform( Space.WorldSpace ).getMatrix();
		var w2c:Matrix44 = this.camera.getProjectionMatrix();
		
		Reflect.setProperty( this.model.material.shader, Register.MODEL_WORLD.ID, m2w );
		Reflect.setProperty( this.model.material.shader, Register.WORLD_CAMERA.ID, w2c );
		Reflect.setProperty( this.model.material.shader, "light", this.light );
		
		var unit:RenderUnit = new RenderUnit();
			unit.context 	= this.model.material.contextSetting;
			unit.shader 	= this.model.material.getInstance();
			unit.mesh 		= this.model.mesh;
		
		// ----------------------- //			
		
		this.renderer.render( [unit] );
	}

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
	
}