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
		//GL11.glDrawArrays( GL11.GL_TRIANGLES, 0, this.currentMesh.signature.numVertices );

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

	public function selectShaderContext():Void
	{
	/*	glEnable(GL_CULL_FACE);
glCullFace(GL_BACK);
glFrontFace(GL_CW);
glEnable(GL_DEPTH_TEST);
glDepthMask(true);
glDepthFunc(GL_LEQUAL);
glDepthRange(0.0f, 1.0f);*/
	}

	/**
	 *
	 * @param	mesh
	 */
	public function selectMesh( mesh:IMeshData, buffer:Java3DMeshBuffer ):Void
	{
		if( !buffer.isAllocated )
			buffer.allocate( mesh );

		if( this.currentMesh != buffer )
		{
			GL30.glBindVertexArray( buffer.ptr_vertexArray );
			GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, buffer.ptr_vertexBuffer );

			this.setVertexAttributes( buffer );

			GL15.glBindBuffer(GL15.GL_ELEMENT_ARRAY_BUFFER, buffer.ptr_indexBuffer );

			// --------- //

			this.currentMesh = buffer;
		}
	}


	/**
	 *
	 * @param	data
	 */
	private function setVertexAttributes( buffer:Java3DMeshBuffer ):Void
	{
		var stride:Int = RegisterHelper.getSignatureSize( buffer.signature ) * 4; // in effing bytes
		var offset:Int = 0;

		for ( t in 0...buffer.signature.numRegisters )
		{
			var register:RegisterType 	= buffer.signature.getRegisterTypeByIndex( t );
			var format:Int 				= this.getVertexBufferFormat( register.format );
			var location:Int 			= this.getVertexAttributeLocation( register );

			GL20.glEnableVertexAttribArray( location );
			GL20.glVertexAttribPointer( location, register.size, format, false, stride, offset );

			offset += register.size * 4;
		}
	}

	/**
	 *
	 * @param	format
	 */
	private function getVertexBufferFormat( format:RegisterFormat ):Int
	{
		switch( format )
		{
			case RegisterFormat.TFLOAT_1: 	return GL11.GL_FLOAT;
			case RegisterFormat.TFLOAT_2: 	return GL11.GL_FLOAT;
			case RegisterFormat.TFLOAT_3: 	return GL11.GL_FLOAT;
			case RegisterFormat.TFLOAT_4: 	return GL11.GL_FLOAT;
			case RegisterFormat.TINT: 		return GL11.GL_INT;

			default:
				throw "not a vertexbuffer format";
		}

		return GL11.GL_FLOAT;
	}

	public function getVertexAttributeLocation( register:RegisterType ):Int
	{
		var location:Int = 0;

		for( j in 0...this.currentShader.getShaderSignature().numRegisters )
		{
			var sregister:RegisterType = this.currentShader.getShaderSignature().getRegisterTypeByIndex( j );

			if( sregister.ID == register.ID )
				return location;

			location += Math.ceil( sregister.size / 4 );
		}

		throw "could not find vertex attrib location";

		return -1;
	}

}