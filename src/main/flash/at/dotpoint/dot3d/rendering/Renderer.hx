package flash.at.dotpoint.dot3d.rendering;

import flash.at.dotpoint.dot3d.DisplayEngine;
import flash.at.dotpoint.dot3d.renderable.buffer.MeshBuffer;
import haxe.at.dotpoint.display.renderable.IRenderable;
import haxe.at.dotpoint.display.rendering.ARenderer;

/**
 * ...
 * @author RK
 */
class Renderer extends ARenderer<DisplayEngine>
{

// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( engine:DisplayEngine )
	{
		super( engine );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @param	entities
	 */
	override public function render( entities:Iterable<IRenderable> ):Void
	{
		this.engine.getContext().context3D.clear( 0.1, 0.1, 0.1 );

		for ( entity in entities )
		{
			this.selectEntity( entity );
			this.drawTriangles();
		}

		this.engine.getContext().context3D.present();
	}

	/**
	 *
	 */
	public function drawTriangles():Void
	{
		this.engine.getContext().context3D.drawTriangles( cast( this.currentMesh.buffer, MeshBuffer ).indexBuffer );
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public function toString():String
	{
		return "[Renderer:flash]";
	}
}