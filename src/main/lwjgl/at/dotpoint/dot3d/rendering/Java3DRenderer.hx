package lwjgl.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshSignature;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.IRenderer;
import haxe.at.dotpoint.display.rendering.register.RegisterFormat;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import lwjgl.at.dotpoint.dot3d.rendering.renderable.Java3DMeshBuffer;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShader;
import lwjgl.at.dotpoint.dot3d.rendering.shader.Java3DShaderProgram;
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

	/**
	 *
	 */
	private var currentShader:Java3DShaderProgram;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{

	}

	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //

	/**
	 *
	 */
	inline public function getContext3D():Java3DContext
	{
		return Stage3DEngine.instance.getContext();
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

		GLFW.glfwSwapBuffers( this.getContext3D().ptr_window ); 				// swap the color buffers
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	public function drawTriangles():Void
	{
		GL11.glDrawElements( GL11.GL_TRIANGLES, this.currentMesh.signature.numTriangles * 3, GL11.GL_UNSIGNED_INT, 0);
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	public function selectShader( shader:Java3DShaderProgram ):Void
	{
		if ( this.currentShader != shader )
		{
			this.currentShader = shader;

			if(!this.currentShader.isCompiled )
				this.currentShader.compile();

			GL20.glUseProgram( this.currentShader.ptr_program );
		}
	}

	/**
	 *
	 */
	public function selectShaderContext():Void
	{
		/*
		glEnable(GL_CULL_FACE);
		glCullFace(GL_BACK);
		glFrontFace(GL_CW);
		glEnable(GL_DEPTH_TEST);
		glDepthMask(true);
		glDepthFunc(GL_LEQUAL);
		glDepthRange(0.0f, 1.0f);
		*/
	}

	/**
	 *
	 * @param	mesh
	 */
	public function selectMesh( mesh:IMeshData, buffer:Java3DMeshBuffer ):Void
	{
		if( this.currentMesh != buffer )
		{
			if( this.currentMesh != null && this.currentMesh.isBound )
				this.currentMesh.unbind();

			this.currentMesh = buffer;
		}

		// -------------- //

		this.currentMesh.dispose();

		if(!this.currentMesh.isAllocated )
			this.currentMesh.allocate( mesh );

		if(!this.currentMesh.isBound )
			this.currentMesh.bind( this.currentShader );
	}


}