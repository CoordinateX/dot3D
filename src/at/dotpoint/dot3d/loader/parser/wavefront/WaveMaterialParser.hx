package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.core.event.Event;
import at.dotpoint.core.event.event.StatusEvent;
import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.loader.processor.ADataProcessor;
import at.dotpoint.loader.processor.IDataProcessor;
import at.dotpoint.loader.URLRequest;
import at.dotpoint.math.vector.Vector3;
import flash.display.BitmapData;
import flash.display3D.Context3DTriangleFace;

/**
 * Parses a single material out of an *.mtl file which might contain a lot of them
 * although it is a regular SingleDataParser should not be used like it and can 
 * only be created from WaveMTLParser
 * 
 * @author RK
 */
class WaveMaterialParser extends ADataProcessor implements IDataProcessor<String,TestShader>
{

	private var input:String;
	public var result(default,null):TestShader;
	
	// ------------------ //
	
	public var name:String;	
	
	private var directoryURL:String;	
	private var pendingTextures:Array<TextureRequest>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	private function new( name:String, directoryURL:String, data:String ) 
	{
		super();
		
		this.name = name;		
		this.input = data;
		
		this.directoryURL = directoryURL;
		this.pendingTextures = new Array<TextureRequest>();
	}
	
	// ************************************************************************ //
	// ISingleDataParser
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function start( request:String ):Void
	{
		this.setStatus( StatusEvent.STARTED );
		
		this.result = new TestShader();
		this.result.contextSetting.culling = Context3DTriangleFace.FRONT;
		
		this.result.name = this.name;
		
		this.parse();
	}
	
	// ************************************************************************ //
	// parseLines
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	input
	 */
	private function parse():Void
	{
		var lineStream:Array<String> = this.input.split( "\r\n" );
			lineStream.reverse();
		
		while ( lineStream.length > 0 )
		{
			var line:String = lineStream.pop();
				line = line.split("\t").join("");
				line = line.split("  ").join(" ");
			
			this.parseLine( line.split(" ") );
		}
		
		this.loadTexture();
	}

	/**
	 * 
	 * @param	line
	 */
	private function parseLine( line:Array<String> ):Void
	{
		var infoType:String = line.shift();
		
		if ( StringTools.trim( infoType ).length == 0 )
			return;
		
		// -------------------------- //
		
		switch ( infoType ) 
		{
			case "Ka":
				this.result.ambientColor = this.parseColor( line );
			
			case "Kd": 
				this.result.diffuseColor = this.parseColor( line );
			
			case "Ks": 
				this.result.specularColor = this.parseColor( line );
			
			case "Ns": 
				this.result.specularWeight = this.parseFloat( line );
			
			case "d":
				this.result.alpha = this.parseFloat( line );
			
			case "illum": 
				return;
				
			case "Ni": 
				return;
				
			case "Tr": 
				return;
				
			case "Tf": 
				return;
				
			case "Ke": 
				return;	
			
			case "map_Ka":
				this.onTexture( line, "ambientMap" );			
			
			case "map_Kd":
				this.onTexture( line, "diffuseMap" );		
			
			case "map_d":
				return;
			
			case "map_bump":
				this.onTexture( line, "normalMap" );	
			
			case "#":
				return;
			
			default:
				trace( "unsupported parsing line: " + infoType + " " + line );
		}
	}
	
	// ************************************************************************ //
	// on XY
	// ************************************************************************ //	
	
	/**
	 * Kd 0.5882 0.5882 0.5882
	 */
	private function parseColor( line:Array<String> ):Vector3
	{
		var r:Float = Std.parseFloat( line[0] );
		var g:Float = Std.parseFloat( line[1] );
		var b:Float = Std.parseFloat( line[2] );
		
		return new Vector3( r, g, b, 1 );
	}
	
	/**
	 * 
	 * @param	line
	 * @return
	 */
	private function parseFloat( line:Array<String> ):Float
	{
		return Std.parseFloat( line[0] );
	}
	
	/**
	 * 
	 * @param	line
	 * @param	type
	 */
	private function onTexture( line:Array<String>, type:String ):Void
	{
		var url:Array<String> = line[0].split("\\");			// D:\Projects\Dotpoint\dot3D\bin\assets\textures\cardboard.jpg
		var dir:Array<String> = this.directoryURL.split("/");	// assets/
		
		for( j in 0...url.length )
		{
			if( url[url.length - j] == dir[0] ) // j = 2 in this example
			{
				url = dir.concat( url.splice(url.length - j + 1, j) );
				break;
			}
		}
		
		var request:TextureRequest = new TextureRequest( new URLRequest( url.join("/") ) );
			request.type = type;
		
		this.pendingTextures.push( request );
	}
	
	// ************************************************************************ //
	// load Texture / complete
	// ************************************************************************ //
	
	/**
	 * starts the next material to parse
	 */
	private function loadTexture():Void
	{
		if( this.pendingTextures.length == 0 )
		{			
			this.setStatus( StatusEvent.COMPLETE );
			return;
		}
		
		var request:TextureRequest = this.pendingTextures[this.pendingTextures.length-1];
			request.load( this.onTextureComplete  );	
	}
	
	/**
	 * when the current parsing material is done, save result and try the next one
	 */
	private function onTextureComplete( event:Event ):Void
	{		
		var request:TextureRequest = this.pendingTextures.pop();
		var data:BitmapData = request.result.bitmapData;
		
		var texture:Texture = new Texture( request.type, data.width, data.height );
			texture.bitmaps.push( data );
		
		Reflect.setProperty( this.result, request.type, texture ); //onto shader
		
		this.loadTexture();
	}
}

private class TextureRequest extends DataRequest
{
	public var type:String;
	
	public function new( request:URLRequest )
	{
		super( request, TextureFormat.instance );
	}
}