package at.dotpoint.dot3d.model;

import at.dotpoint.core.entity.Component;
import at.dotpoint.display.components.renderable.IRenderable;
import at.dotpoint.display.components.renderable.RenderType;
import at.dotpoint.display.DisplayObject;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.math.vector.Vector3;
import hxsl.Shader;

class Model extends DisplayObject
{

	/**
	 * 
	 */
	public var name:String;
	
	/**
	 * IRenderable
	 */
	public var model(get, set):ModelEC;
	
	/**
	 * geometry: vertex + index buffer
	 */
	public var mesh(get, set):Mesh;
	
	/**
	 * material, shader, textures - can also be applied to mesh sub regions only 
	 */
	public var material(get, set):Material<Shader>;		
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( ?mesh:Mesh, ?material:Material<Shader> ) 
	{
		super();	
		
		this.addComponent( new ModelEC() );
		
		this.mesh = mesh;
		this.material = material;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 * @return
	 */
	private function get_model():ModelEC { return cast this.renderable; }
	
	private function set_model( value:ModelEC ):ModelEC 
	{ 
		return cast this.renderable = value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_mesh():Mesh { return this.model.mesh; }
	
	private function set_mesh( value:Mesh ):Mesh 
	{ 
		this.model.mesh = value;
		
		if( this.model.mesh != null )
		{
			this.calculateBoundings();
		}
		
		return value;
	}
	
	/**
	 * 
	 * @return
	 */
	private function get_material():Material<Shader> { return this.model.material; }
	
	private function set_material( value:Material<Shader> ):Material<Shader> 
	{ 
		return this.model.material = value;
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * 
	 */
	private function calculateBoundings():Void
	{
		this.boundings.modelSpace.reset();
		
		// ------------- //
		
		var length:Int = this.mesh.data.signature.getNumEntries( Register.VERTEX_POSITION );
		
		var data:Array<Float> = new Array<Float>();
		var vertex:Vector3 = new Vector3();
		
		for( v in 0...length )
		{
			this.mesh.data.getVertexData( Register.VERTEX_POSITION, v, data );
			
			vertex.x = data[0];
			vertex.y = data[1];
			vertex.z = data[2];
			
			this.boundings.modelSpace.insertPoint( vertex );
		}
	}
}

/**
 * Model is a combination of pure geometry (Mesh) and a collection of Materials applied to specific regions of the Mesh
 * The Mesh maybe shared between many different Models. 
 * <br/><br/>
 * Models with the same geometry might have different materials. For example a character might be as any other character, 
 * but has a different Material. In this case the Mesh is the same, but the MeshMaterial is different. The MeshMaterial 
 * might be very similar like any other character but might has a different diffuse Texture. 
 * 
 * @author Gerald Hattensauer
 */
class ModelEC extends Component implements IRenderable
{
	
	/**
	 * 
	 */
	public var renderType:RenderType;
	
	/**
	 * geometry: vertex + index buffer
	 */
	public var mesh:Mesh;
	
	/**
	 * material, shader, textures - can also be applied to mesh sub regions only 
	 */
	public var material:Material<Shader>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( ?mesh:Mesh, ?material:Material<Shader> ) 
	{
		super();
		
		this.mesh = mesh;
		this.material = material;
	}	
	
	/**
	 * 
	 */
	public function render():Void
	{
		return;
	}
	
}

