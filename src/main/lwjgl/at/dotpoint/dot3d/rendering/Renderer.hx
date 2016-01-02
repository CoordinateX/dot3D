package lwjgl.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.renderable.IRenderable;
import haxe.at.dotpoint.display.rendering.ARenderer;
import lwjgl.at.dotpoint.dot3d.DisplayEngine;
import lwjgl.at.dotpoint.dot3d.renderable.buffer.MeshBuffer;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL15;
import org.lwjgl.opengl.GL20;
import org.lwjgl.opengl.GL30;
import org.lwjgl.opengl.GLContext;
import org.lwjgl.glfw.GLFW;

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
		GL11.glClear( GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT ); 	// clear the framebuffer

		for ( entity in entities )
		{
			this.selectEntity( entity );
			this.drawTriangles();
		}

		GLFW.glfwSwapBuffers( this.engine.getContext().ptr_window ); 			// swap the color buffers
	}

	/**
	 *
	 */
	public function drawTriangles():Void
	{
		GL11.glDrawElements( GL11.GL_TRIANGLES, this.currentMesh.data.signature.numTriangles * 3, GL11.GL_UNSIGNED_INT, 0);
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
		return "[Renderer:lwjgl]";
	}
}