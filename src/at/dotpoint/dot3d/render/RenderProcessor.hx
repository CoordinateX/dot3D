package at.dotpoint.dot3d.render;

import at.dotpoint.core.dispatcher.Event;
import at.dotpoint.core.dispatcher.event.StatusEvent;
import at.dotpoint.core.dispatcher.EventDispatcher;
import at.dotpoint.logger.Log;
import at.dotpoint.dot3d.model.material.ContextSettings;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshBuffer;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.RegisterType;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.utils.Endian;
import haxe.io.BytesData;
import hxsl.Shader;

/**
 * ...
 * @author RK
 */
@:access(at.dotpoint.dot3d.model.mesh)
 //
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
	
	private var currentContext:ContextSettings;
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
			this.addListener( StatusEvent.COMPLETE, onComplete );
		
		if ( this.context != null )
		{
			Log.warn( "already initialized" );
			
			this.dispatch( new StatusEvent( StatusEvent.COMPLETE ) );			
			return;
		}
		
		this.viewport.stage3D.addEventListener( flash.events.Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.viewport.stage3D.addEventListener( flash.events.ErrorEvent.ERROR, this.onContextCreationError );
		
		this.viewport.stage3D.requestContext3D();
	}
	
	// ************************************************************************ //
	// Setup
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function onContextCreated( event:flash.events.Event ):Void
	{
		this.context = this.viewport.context;		
		this.context.configureBackBuffer( this.viewport.width, this.viewport.height, 0, true );	
		
		#if debug
			this.context.enableErrorChecking = true; 
		#end 
		
		this.viewport.stage3D.removeEventListener( flash.events.Event.CONTEXT3D_CREATE, this.onContextCreated );
		this.viewport.stage3D.removeEventListener( flash.events.ErrorEvent.ERROR, this.onContextCreationError );
		
		this.dispatch( new StatusEvent( StatusEvent.COMPLETE ) );
	}
	
	/**
	 * 
	 */
	private function onContextCreationError( event:flash.events.ErrorEvent ):Void 
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
			unit.material.applyInput( unit.shaderInput );
			
			// ------------------- //
			
			this.selectShader( unit.shader );				
			
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
	private function selectShader( shader:Shader ):Void
	{
		var instance:ShaderInstance = shader.getInstance(); // call only once before drawing!
		
		if ( this.currentShader != instance )
		{
			this.setProgram( instance );
			
			this.currentShader = instance;			
			this.currentShader.varsChanged = true;
			
			this.currentMesh = null; // new shader must be filled with new vertex buffer
		}		
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
		if( this.currentContext == null 
		||  settings.culling 	!= this.currentContext.culling )
		{			
			this.context.setCulling( settings.culling );
		}
		
		if( this.currentContext 	== null 
		||  settings.depthTest 		!= this.currentContext.depthTest 
		||  settings.depthTestMode 	!= this.currentContext.depthTestMode )
		{			
			this.context.setDepthTest( settings.depthTest, settings.depthTestMode );
		}
		
		this.currentContext = settings;
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
		var signature:MeshSignature = mesh.data.signature;
		
		var pos:Int 	= 0;
		var offset:Int 	= 0;
		
		for ( t in 0...signature.size() )
		{
			var register:RegisterType = signature.getTypeByIndex( t );
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