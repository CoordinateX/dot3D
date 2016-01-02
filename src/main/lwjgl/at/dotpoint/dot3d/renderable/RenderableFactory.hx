package lwjgl.at.dotpoint.dot3d.renderable;
import haxe.at.dotpoint.display.renderable.material.buffer.IMaterialBuffer;
import haxe.at.dotpoint.display.renderable.material.data.IMaterialData;
import haxe.at.dotpoint.display.renderable.mesh.buffer.IMeshBuffer;
import haxe.at.dotpoint.display.renderable.mesh.data.IMeshData;
import haxe.at.dotpoint.display.renderable.shader.buffer.IShaderBuffer;
import haxe.at.dotpoint.display.renderable.shader.data.IShaderData;
import haxe.at.dotpoint.dot3d.renderable.shader.DefaultShader;
import lwjgl.at.dotpoint.dot3d.renderable.buffer.MaterialBuffer;
import lwjgl.at.dotpoint.dot3d.renderable.buffer.MeshBuffer;
import lwjgl.at.dotpoint.dot3d.renderable.shader.DefaultShaderBuffer;

/**
 * ...
 * @author RK
 */
class RenderableFactory extends haxe.at.dotpoint.display.renderable.RenderableFactory
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	data
	 * @return
	 */
	override public function createMeshBuffer( data:IMeshData ):IMeshBuffer
	{
		return new MeshBuffer();
	}

	/**
	 *
	 * @param	data
	 * @return
	 */
	override public function createMaterialBuffer( data:IMaterialData ):IMaterialBuffer
	{
		return new MaterialBuffer();
	}

	/**
	 *
	 * @param	data
	 * @return
	 */
	override public function createShaderBuffer( data:IShaderData ):IShaderBuffer
	{
		switch( data.name )
		{
			case DefaultShader.NAME:
				return new DefaultShaderBuffer();

			default:
				throw "cannot find shader for: " + data.name;
		}

		return null;
	}
}