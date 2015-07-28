package java.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshSignature;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.IRenderer;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import java.at.dotpoint.dot3d.rendering.renderable.Java3DMeshBuffer;
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
class Java3DRenderer implements IRenderer
{

	/**
	 *
	 */
	private var currentMesh:Java3DMeshBuffer;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{

	}

	// ************************************************************************ //
	// Rendering
	// ************************************************************************ //

	/**
	 *
	 * @param	entities
	 */
	public function render( entities:Iterable<IDisplayObject> ):Void
	{
		GL11.glClear( GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT ); 	// clear the framebuffer

		for ( entity in entities )
		{
			entity.getRenderer().render();
		}

		GLFW.glfwSwapBuffers( this.ptr_window ); 								// swap the color buffers
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 * @param	mesh
	 */
	public function selectMesh( mesh:IMeshData, buffer:Java3DMeshBuffer ):Void
	{
		if(!buffer.isAllocated )
			buffer.allocate( mesh );

		if( this.currentMesh != buffer )
		{
			GL30.glBindVertexArray( buffer.ptr_vertexArray );
			this.currentMesh = buffer;
		}
	}


}