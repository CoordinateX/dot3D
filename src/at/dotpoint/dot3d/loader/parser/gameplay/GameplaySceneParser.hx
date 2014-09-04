package at.dotpoint.dot3d.loader.parser.gameplay;

import at.dotpoint.core.event.event.StatusEvent;
import at.dotpoint.dot3d.loader.parser.gameplay.GameplayMeshParser;
import at.dotpoint.dot3d.shader.TestShader;
import at.dotpoint.loader.DataRequest;
import at.dotpoint.loader.processor.ADataProcessor;
import at.dotpoint.loader.processor.IDataProcessor;
import at.dotpoint.dot3d.model.Model;
import haxe.ds.Vector;
/**
 * ...
 * @author RK
 */
class GameplaySceneParser extends ADataProcessor implements IDataProcessor< String, Vector<Model> >
{

	/**
	 * 
	 */
	public var result(default, null):Vector<Model>;
	
	// ------------------ //
	
	private var input:Xml;
	private var directoryURL:String;
	
	private var subParser:Array<GameplayMeshParser>;
	private var materialLoader:DataRequest;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		super();	
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function start( request:String ):Void
	{
		this.input = Xml.parse( request );	
		
		this.setStatus( StatusEvent.STARTED );
		
		//this.startMaterials();
		this.startObjects();
		
		this.setStatus( StatusEvent.COMPLETE );
	}
	
	// ************************************************************************ //
	// parse objects
	// ************************************************************************ //
	
	/**
	 * find seperate objects and delegate parsing for each individual object
	 */
	private function startObjects():Void
	{
		this.subParser = new Array<GameplayMeshParser>();
		
		for( meshNode in this.input.firstChild().elementsNamed("Mesh") ) 
		{
			var name:String = meshNode.get( "id" );
				name = name.substring( 0, name.lastIndexOf("_") );
			
			this.subParser.push( new GameplayMeshParser( name, meshNode ) );
		}
		
		this.result = new Vector<Model>( this.subParser.length );
		this.parseObjects();
	}
	
	/**
	 * 
	 */
	private function parseObjects():Void
	{
		for( p in 0...this.subParser.length )
		{
			var parser:GameplayMeshParser = this.subParser[p];
				parser.start( null );
			
			var model:Model = new Model( parser.result, new TestShader() );
			//	model.name = parser.name;
				
			this.result[p] = model;
		}
	}
}