package at.dotpoint.dot3d.loader.parser.wavefront;

import at.dotpoint.dot3d.loader.format.TextureFormat;
import at.dotpoint.dot3d.model.material.Material;
import at.dotpoint.dot3d.model.material.Texture;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.loader.parser.ABaseParser;
import at.dotpoint.loader.parser.ISingleDataParser;
import at.dotpoint.math.vector.Vector3;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.net.URLRequest;
import flash.display3D.Context3DTriangleFace;

/**
 * Parses a single material out of an *.mtl file which might contain a lot of them
 * although it is a regular SingleDataParser should not be used like it and can 
 * only be created from WaveMTLParser
 * 
 * @author RK
 */
class WaveMaterialParser extends ABaseParser implements ISingleDataParser<String,Material>
{

	private var input:String;
	private var output:TestShader;
	
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
	public function parse( request:String ):Void
	{
		this.setParsing();
		
		this.output = new TestShader();
		this.output.contextSetting.culling = Context3DTriangleFace.FRONT;
		
		this.output.name = this.name;
		
		this.start();
	}
	
	/**
	 * 
	 */
	public function close():Void
	{
		throw "close() not supported";
	}
	
	/**
	 * 
	 * @return
	 */
	public function getData():Material
	{
		return this.output;
	}
	
	// ************************************************************************ //
	// parseLines
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	input
	 */
	private function start():Void
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
				this.output.ambientColor = this.parseColor( line );
			
			case "Kd": 
				this.output.diffuseColor = this.parseColor( line );
			
			case "Ks": 
				this.output.specularColor = this.parseColor( line );
			
			case "Ns": 
				this.output.specularWeight = this.parseFloat( line );
			
			case "d":
				this.output.alpha = this.parseFloat( line );
			
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
			this.setComplete();
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
		var data:BitmapData = request.getData().bitmapData;
		
		var texture:Texture = new Texture( request.type, data.width, data.height );
			texture.bitmaps.push( data );
		
		Reflect.setProperty( this.output, request.type, texture );
		
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