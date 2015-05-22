package flash.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.display.renderable.geometry.mesh.IMeshData;
import haxe.at.dotpoint.display.renderable.geometry.mesh.MeshSignature;
import haxe.at.dotpoint.display.renderable.IDisplayObject;
import haxe.at.dotpoint.display.rendering.register.RegisterFormat;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.display.rendering.IRenderer;
import haxe.at.dotpoint.display.scene.IScene;
import flash.at.dotpoint.dot3d.rendering.renderable.Flash3DMeshBuffer;
import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShader;
import flash.at.dotpoint.dot3d.rendering.shader.Flash3DShaderContext;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.utils.Endian;
import haxe.at.dotpoint.dot3d.Stage3DEngine;
import haxe.io.BytesData;
import hxsl.Shader.ShaderInstance;

/**
 * ...
 * @author RK
 */
class Flash3DRenderer implements IRenderer
{
	
	/**
	 * 
	 */
	private var currentShader:ShaderInstance;
	
	/**
	 * 
	 */
	private var currentMesh:Flash3DMeshBuffer;
	
	/**
	 * 
	 */
	private var currentContext:Flash3DShaderContext;
	
	/**
	 * 
	 */
	private var currentVertexBufferLength:Int;
	
	/**
	 * 
	 */
	//private var currentTextures:Array<Texture>;
	
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
	inline public function getContext3D():Context3D
	{
		return Stage3DEngine.instance.getContext().context3D;
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
		this.getContext3D().clear( 0.1, 0.1, 0.1 );
		
		for ( entity in entities )
		{
			entity.getRenderer().render();
		}
		
		this.getContext3D().present();
	}
	
	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //
	// SelectShader:
	
	/**
	 * 
	 */
	public function selectShader( shader:Flash3DShader ):Void 
	{
		var instance:ShaderInstance = shader.getShaderInstance(); 	// call only once before drawing!
		
		if ( this.currentShader != instance )
		{
			this.setProgram( instance );
			
			this.currentShader = instance;			
			this.currentShader.varsChanged = true;
			
			this.currentMesh = null; 								// new shader must be filled with new vertex buffer
		}	
		
		if( this.currentShader.varsChanged )
			this.updateShaderVariables();
	}
	
	/**
	 * change the shader program of the context and build the program if necessary
	 * @param	shader
	 */
	private function setProgram( shader:ShaderInstance ):Void
	{
		if( shader.program == null ) 
		{
			shader.program = this.getContext3D().createProgram();
			
			var vdata:BytesData = shader.vertexBytes.getData();
				vdata.endian = Endian.LITTLE_ENDIAN;
			
			var fdata:BytesData = shader.fragmentBytes.getData();			
				fdata.endian = Endian.LITTLE_ENDIAN;
			
			shader.program.upload( vdata, fdata );
		}
		
		this.getContext3D().setProgram( shader.program );
	}
	
	/**
	 * 
	 */
	private function updateShaderVariables():Void
	{		
		this.currentShader.varsChanged = false;
		
		this.getContext3D().setProgramConstantsFromVector( Context3DProgramType.VERTEX,   0, this.currentShader.vertexVars.toData()   );
		this.getContext3D().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, this.currentShader.fragmentVars.toData() );
		
		// --------------------------- //
		
		/*for( i in 0...this.currentShader.textures.length ) 
		{
			var texture:Texture = this.currentShader.textures[i];
			
			if( texture != this.currentTextures[i] ) 
			{
				if( !texture.isAllocated )
					texture.allocate( this.context );
				
				this.getContext3D().setTextureAt( i, texture.texture );
				this.currentTextures[i] = texture;
			}
		}	
		
		while( this.currentTextures.length > this.currentShader.textures.length )
		{
			this.getContext3D().setTextureAt( this.currentTextures.length - 1, null );
			this.currentTextures.pop();
		}*/
	}
	
	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //
	// SelectShaderContext:	
	
	/**
	 * 
	 */
	public function selectShaderContext( settings:Flash3DShaderContext ):Void 
	{
		if( this.currentContext == null )
		{
			this.getContext3D().setCulling( settings.culling );
			this.getContext3D().setDepthTest( settings.depthTest, settings.depthTestMode );			
		}
		else
		{
			if( settings.culling != this.currentContext.culling )
			{			
				this.getContext3D().setCulling( settings.culling );
			}
			
			if( settings.depthTest != this.currentContext.depthTest	|| settings.depthTestMode != this.currentContext.depthTestMode )
			{			
				this.getContext3D().setDepthTest( settings.depthTest, settings.depthTestMode );
			}
		}	
		
		this.currentContext = settings;
	}
	
	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //
	// SelectMesh:	
	
	/**
	 * 
	 * @param	mesh
	 */
	public function selectMesh( mesh:IMeshData, buffer:Flash3DMeshBuffer ):Void
	{
		if(!buffer.isAllocated )
			buffer.allocate( this.getContext3D(), mesh );
		
		this.setVertexBuffer( buffer );
		this.currentMesh = buffer;		
	}
	
	/**
	 * 
	 * @param	mesh
	 */
	private function setVertexBuffer( buffer:Flash3DMeshBuffer ):Void
	{
		var signature:MeshSignature = buffer.signature;
		var context3D:Context3D = this.getContext3D();
		
		// --------------- //
		
		var pos:Int 	= 0;
		var offset:Int 	= 0;		
		
		for ( t in 0...signature.numRegisters )
		{
			var register:RegisterType = signature.getRegisterTypeByIndex( t );
			var index:Int = this.indexOfVertexBuffer( register.ID );
			
			if ( index != -1 )
			{
				context3D.setVertexBufferAt( pos, buffer.vertexBuffer, offset, this.getVertexBufferFormat( register.format ) ); 
				pos++;
			}			
			
			offset += register.size;			
		}
		
		// --------------- //
		// enough buffer?
		
		if ( pos < this.currentShader.bufferNames.length )
		{
			throw "missing vertexBuffer";
		}
		
		// --------------- //
		// null reset:
		
		for ( i in pos...this.currentVertexBufferLength )
		{
			context3D.setVertexBufferAt( i, null );
		}
		
		this.currentVertexBufferLength = pos;
	}
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	private function indexOfVertexBuffer( name:String ):Int
	{
		var list:Array<String> = this.currentShader.bufferNames;
		
		for ( i in 0...list.length )
		{
			if ( list[i] == name ) return i;
		}
		
		return -1;
	}

	/**
	 * 
	 * @param	format
	 */
	private function getVertexBufferFormat( format:RegisterFormat ):Context3DVertexBufferFormat
	{
		switch( format )
		{
			case RegisterFormat.TFLOAT_1: 	return Context3DVertexBufferFormat.FLOAT_1;
			case RegisterFormat.TFLOAT_2: 	return Context3DVertexBufferFormat.FLOAT_2;
			case RegisterFormat.TFLOAT_3: 	return Context3DVertexBufferFormat.FLOAT_3;
			case RegisterFormat.TFLOAT_4: 	return Context3DVertexBufferFormat.FLOAT_4;
			case RegisterFormat.TINT: 		return Context3DVertexBufferFormat.BYTES_4; //?
			
			default: 		
				throw "not a vertexbuffer format";
		}
		
		return Context3DVertexBufferFormat.BYTES_4;
	}
}