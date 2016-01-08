package flash.at.dotpoint.dot3d.renderable;

import flash.at.dotpoint.dot3d.DisplayEngine;
import haxe.at.dotpoint.display.renderable.material.buffer.IMaterialBuffer;
import haxe.at.dotpoint.display.renderable.material.data.IMaterialData;
import haxe.at.dotpoint.display.renderable.mesh.buffer.IMeshBuffer;
import haxe.at.dotpoint.display.renderable.mesh.data.IMeshData;
import haxe.at.dotpoint.display.renderable.shader.buffer.IShaderBuffer;
import haxe.at.dotpoint.display.renderable.shader.data.IShaderData;
import haxe.at.dotpoint.dot3d.renderable.shader.DefaultShader;
import flash.at.dotpoint.dot3d.renderable.buffer.MaterialBuffer;
import flash.at.dotpoint.dot3d.renderable.buffer.MeshBuffer;
import flash.at.dotpoint.dot3d.renderable.shader.DefaultShaderBuffer;

/**
 * ...
 * @author RK
 */
class RenderableFactory extends haxe.at.dotpoint.display.renderable.RenderableFactory
{

	/**
	 *
	 */
	private var engine:DisplayEngine;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( engine:DisplayEngine )
	{
		super();

		this.engine = engine;
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
		return new MeshBuffer( this.engine.getContext().context3D );
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
				return new DefaultShaderBuffer( this.engine.getContext().context3D );

			default:
				throw "cannot find shader for: " + data.name;
		}

		return null;
	}
}