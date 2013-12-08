package at.dotpoint.dot3d.render;

import at.dotpoint.dot3d.model.material.ContextSettings;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshBuffer;
import at.dotpoint.dot3d.model.register.RegisterType;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import hxsl.Shader;
import haxe.io.BytesData;
import flash.utils.Endian;

/**
 * ...
 * @author RK
 */
class RenderProcessor extends EventDispatcher
{

	/**
	 * settings like dimensions
	 */
	public var viewport(default, null):Viewport;	
	
	/**
	 * drawn on
	 */
	public var context(default,null):Context3D;
	
	// ------------------------------------------ //
	
	private var currentShader:ShaderInstance;
	private var currentMesh:MeshBuffer;
	
	private var currentVertexBufferLength:Int;
	private var currentTextures:Array<Texture>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( viewport:Viewport ) 
	{
		super();	
		
		this.viewport = viewport;	
		this.currentTextures = new Array<Texture>();
	}
	
	/**
	 * 
	 */
	public function init( ?onComplete:Event->Void ):Void
	{
		if( onComplete != null )
			this.addEventListener( Event.COMPLETE, onComplete, false, 0, true  );
		
		if ( this.context != null )
		{
			trace( "already initialized" );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );			
			return;
		}
		
		this.viewport.stage3D.addEventListener( Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.viewport.stage3D.addEventListener( ErrorEvent.ERROR, this.onContextCreationError );
		
		this.viewport.stage3D.requestContext3D();
	}
	
	// ************************************************************************ //
	// Setup
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function onContextCreated( event:Event ):Void
	{
		this.context = this.viewport.context;		
		this.context.configureBackBuffer( this.viewport.width, this.viewport.height, 0, true );	
		
		#if debug
			this.context.enableErrorChecking = true; 
		#end 
		
		this.viewport.stage3D.removeEventListener( Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.viewport.stage3D.removeEventListener( ErrorEvent.ERROR, this.onContextCreationError );
		
		this.dispatchEvent( new Event( Event.COMPLETE ) );
	}
	
	/**
	 * 
	 */
	private function onContextCreationError( event:ErrorEvent ):Void 
	{
		throw "unknown stage3D error; ID: " +  event.errorID;
	}
	
	// ************************************************************************ //
	// Rendering
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	public function render( list:Iterable<RenderUnit> ):Void
	{
		this.context.clear( 0.1, 0.1, 0.1 );
		
		for ( unit in list )
		{
			if ( this.currentShader != unit.shader )
				this.selectShader( unit.shader );		
			
			// ------------------- //
			
			if( this.currentShader.varsChanged )
				this.updateShaderVars();
			
			this.updateContextSettings( unit.context );		
			
			// ------------------- //
			
			if ( this.currentMesh != unit.mesh.buffer )
				this.selectMesh( unit.mesh );
			
			// ------------------- //	
			
			this.context.drawTriangles( this.currentMesh.indexBuffer );
		}
		
		this.context.present();
	}	

	
	// ---------------------------------------------------------- //
	// ---------------------------------------------------------- //
	// Material:
	
	/**
	 * 
	 * @param	material
	 */
	private function selectShader( shader:ShaderInstance ):Void
	{
		this.setProgram( shader );
		
		this.currentShader = shader;			
		this.currentShader.varsChanged = true;
		
		this.currentMesh = null; // new shader must be filled with new vertex buffer
	}	
	
	/**
	 * change the shader program of the context and build the program if necessary
	 * @param	shader
	 */
	private function setProgram( shader:ShaderInstance ):Void
	{
		if ( shader.program == null ) 
		{
			shader.program = this.context.createProgram();
			
			var vdata:BytesData = shader.vertexBytes.getData();
				vdata.endian = Endian.LITTLE_ENDIAN;
			
			var fdata:BytesData = shader.fragmentBytes.getData();			
				fdata.endian = Endian.LITTLE_ENDIAN;
			
			shader.program.upload(vdata, fdata);
		}
		
		this.context.setProgram( shader.program );
	}
	
	/**
	 * 
	 */
	private function updateShaderVars():Void
	{		
		this.currentShader.varsChanged = false;
		
		this.context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 0, this.currentShader.vertexVars.toData() );
		this.context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, this.currentShader.fragmentVars.toData() );
		
		// --------------------------- //
		
		for ( i in 0...this.currentShader.textures.length ) 
		{
			var texture:Texture = this.currentShader.textures[i];
			
			if ( texture != this.currentTextures[i] ) 
			{
				if ( !texture.isAllocated )
					texture.allocate( this.context );
				
				this.context.setTextureAt( i, texture.texture );
				this.currentTextures[i] = texture;
			}
		}	
		
		while ( this.currentTextures.length > this.currentShader.textures.length )
		{
			this.context.setTextureAt( this.currentTextures.length - 1, null );
			this.currentTextures.pop();
		}
	}
	
	/**
	 * 
	 * @param	settings
	 */
	private function updateContextSettings( settings:ContextSettings ):Void
	{
		this.context.setCulling( settings.culling );
		this.context.setDepthTest( settings.depthTest, settings.depthTestMode );
	}
	
	// ---------------------------------------------------------- //
	// ---------------------------------------------------------- //
	// Buffer / Mesh:
	
	/**
	 * 
	 * @param	mesh
	 */
	private function selectMesh( mesh:Mesh ):Void
	{
		if ( !mesh.buffer.isAllocated )
			mesh.buffer.allocate( this.context, mesh.data );
		
		this.setVertexBuffer( mesh );
		this.currentMesh = mesh.buffer;		
	}
	
	/**
	 * 
	 * @param	mesh
	 */
	private function setVertexBuffer( mesh:Mesh ):Void
	{
		var types:Array<RegisterType> = mesh.data.vertices.getRegisterTypes();
		
		var pos:Int 	= 0;
		var offset:Int 	= 0;
		
		for ( register in types )
		{
			var index:Int = this.indexOfVertexBuffer( register.ID );
			
			if ( index != -1 )
			{
				this.context.setVertexBufferAt( pos, mesh.buffer.vertexBuffer, offset, RegisterType.getVertexBufferFormat( register.format ) ); 
				pos++;
			}			
			
			offset += register.size;			
		}
		
		// enough buffer?
		if ( pos < this.currentShader.bufferNames.length )
		{
			throw "missing vertexBuffer";
		}
		
		// null rest:
		for ( i in pos...this.currentVertexBufferLength )
		{
			this.context.setVertexBufferAt( i, null );
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
	
}