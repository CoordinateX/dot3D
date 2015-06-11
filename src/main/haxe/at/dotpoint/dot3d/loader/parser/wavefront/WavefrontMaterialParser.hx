package haxe.at.dotpoint.dot3d.loader.parser.wavefront;

import haxe.at.dotpoint.core.dispatcher.event.Event;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.display.renderable.bitmap.BitmapData;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.dot3d.material.DiffuseTextureMaterial;
import haxe.at.dotpoint.dot3d.rendering.renderable.Texture;
import haxe.at.dotpoint.loader.DataRequest;
import haxe.at.dotpoint.loader.format.BitmapFormat;
import haxe.at.dotpoint.loader.processor.ADataProcessor;
import haxe.at.dotpoint.loader.processor.IDataProcessor;
import haxe.at.dotpoint.loader.URLRequest;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.ds.Vector;

/**
 * newmtl cardboard
 *	Ns 10.0000
 *	Ni 1.5000
 *	d 1.0000
 *	Tr 0.0000
 *	Tf 1.0000 1.0000 1.0000 
 *	illum 2
 *	Ka 0.5880 0.5880 0.5880
 *	Kd 0.5880 0.5880 0.5880
 *	Ks 0.0000 0.0000 0.0000
 *	Ke 0.0000 0.0000 0.0000
 *	map_Ka D:\Projects\Dotpoint\dot3D\assets\textures\cardboard.jpg
 *	map_Kd D:\Projects\Dotpoint\dot3D\assets\textures\cardboard.jpg
 */
class WavefrontMaterialParser extends ADataProcessor implements IDataProcessor<String,DiffuseTextureMaterial>
{
	/**
	 * 
	 */
	private var input:String;
	
	/**
	 * 
	 */
	public var result(default:null):DiffuseTextureMaterial;
	
	// ------------------ //
	
	/**
	 * material name (newmtl xy)
	 */
	public var name:String;	
	
	/**
	 * url textures are loaded relative to
	 */
	private var directoryURL:String;
	
	/**
	 * 
	 */
	private var pendingTextures:Array<TextureRequest>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( name:String, directoryURL:String, data:String ) 
	{
		super();	
		
		this.name = name;		
		this.input = data;
		
		this.directoryURL = directoryURL;
		this.pendingTextures = new Array<TextureRequest>();
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function start( input:String ):Void
	{
		this.setStatus( StatusEvent.STARTED );
		
		this.result = new DiffuseTextureMaterial( null );		
		this.result.name = this.name;
		
		if( input != null )			// usually null (when loaded via MaterialLibraryParser)
			this.input = input;		// and this.input is usually already set
		
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
	 * starts the next material to parse or dispatches complete when everything is parsed and textures loaded
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
		var texture:Texture = new Texture( request.result );
		
		Reflect.setProperty( this.result, request.type, texture ); //onto shader
		
		this.loadTexture();
	}
}

/**
 * 
 */
private class TextureRequest extends DataRequest
{
	public var type:String;
	
	public function new( request:URLRequest )
	{
		super( request, BitmapFormat.instance );
	}
}
