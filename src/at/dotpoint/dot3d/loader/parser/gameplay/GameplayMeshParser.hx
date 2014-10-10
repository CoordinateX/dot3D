package at.dotpoint.dot3d.loader.parser.gameplay;

import at.dotpoint.core.event.event.StatusEvent;
import at.dotpoint.dot3d.model.mesh.Mesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.loader.processor.ADataProcessor;
import at.dotpoint.loader.processor.IDataProcessor;

/**
 * ...
 * @author RK
 */
class GameplayMeshParser extends ADataProcessor implements IDataProcessor<Xml,Mesh>
{

	/**
	 * 
	 */
	public var result(default, null):Mesh;
	
	// -------------- //
	
	/**
	 * 
	 */
	private var input:Xml;
	
	/**
	 * 
	 */
	public var name:String;
	
	// -------------- //
	
	private var input_registers:Array<RegisterType>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( name:String, input:Xml ) 
	{
		super();	
		
		this.name = name;
		this.input = input;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	
	
	/**
	 * 
	 * @param	request
	 */
	public function start( request:Xml ):Void
	{
		this.setStatus( StatusEvent.STARTED );
		
		this.parse();
		
		this.setStatus( StatusEvent.COMPLETE );
	}
	
	/**
	 * 
	 */
	private function parse():Void
	{
		this.result = new Mesh( this.parseMeshSignature() );	
		
		this.parseVertices();
		this.parseFaces();
	}
	
	// ************************************************************************ //
	// MeshSignature
	// ************************************************************************ //	
	
	/**
	 * 
	 * @return
	 */
	private function parseMeshSignature():MeshSignature
	{
		var numVertices:Int 	= this.getVerticeCount();
		var numFaces:Int		= this.getFaceCount();
		var numRegisters:Int 	= this.getRegisterCount();		
		
		var signature:MeshSignature = new MeshSignature( numVertices, numFaces, numRegisters );
		
		// ------------------ //
		
		this.input_registers = new Array<RegisterType>();
		
		for( vertexElement in this.input.elementsNamed( "VertexElement" ) )
		{
			var type:RegisterType = null;
			
			for( element in vertexElement.elements() )
			{
				if( element.nodeName != "usage" )
					continue;
				
				switch( element.firstChild().toString() )
				{
					case "POSITION":
					{
						type = Register.VERTEX_POSITION;
						break;
					}
					
					case "NORMAL":
					{
						type = Register.VERTEX_NORMAL;
						break;
					}
					
					case "TEXCOORD0":
					{
						type = Register.VERTEX_UV;
						break;
					}
				}
			}
			
			if( type == null )
				throw "unknown vertexElement usage";
			
			signature.addType( type, numVertices );
			
			this.input_registers.push( type );
		}
		
		return signature;
	}
	
	/**
	 * 
	 * @return
	 */
	private function getVerticeCount():Int
	{
		for( element in this.input.elementsNamed( "vertices" ) )
		{
			return Std.parseInt( element.get("count") ); 
		}
		
		return -1;
	}
	
	/**
	 * 
	 * @return
	 */
	private function getFaceCount():Int
	{
		for( element in this.input.elementsNamed( "MeshPart" ) )
		{
			for( indices in element.elementsNamed( "indices" ) )			
			{
				return Std.int( Std.parseInt( indices.get("count") ) / 3 ); 
			}
		}
		
		return -1;
	}
	
	/**
	 * 
	 * @return
	 */
	private function getRegisterCount():Int 
	{
		var count:Int = 0;
		
		for( vertexElement in this.input.elementsNamed( "VertexElement" ) )
		{
			count++;
		}
		
		return count;
	}
	
	// ************************************************************************ //
	// Vertex
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function parseVertices():Void
	{
		var vertices:String;
		
		for( element in this.input.elementsNamed( "vertices" ) )
		{
			vertices = element.toString();
			break;
		}
		
		// ------------- //
		
		var data:Array<Float> = new Array<Float>();
		
		var line:EReg = ~/(\-?[0-9]+\.?[0-9]*\s){1}/;
		var p:Int = 0;
		
		while( line.matchSub( vertices, p ) )
		{			
			data.push( Std.parseFloat( line.matched(0) ) );
			p = line.matchedPos().pos + line.matchedPos().len; 	
		}
		
		this.setVertexData( data );
	}
	
	/**
	 * 
	 * @param	vdata
	 */
	private function setVertexData( vdata:Array<Float> ):Void
	{
		var signature:MeshSignature = this.result.data.signature;
		var vindices:Array<Int> = new Array<Int>();
		
		for( v in 0...signature.numVertices )
		{			
			var index:Int 	= v * signature.getTotalRegisterSize();
			var offset:Int 	= 0;
			
			for( t in 0...this.input_registers.length )
			{					
				var type:RegisterType = this.input_registers[t];
				
				var start:Int = index + offset;
				var end:Int = start + type.size;
				
				this.result.data.setVertexData( type, v, vdata.slice( start, end ) );
				
				// ------------- //
				
				offset += type.size;	
				vindices[t] = v;
			}			
			
			this.result.data.setVertexIndices( v, vindices );
		}
	}
	
	// ************************************************************************ //
	// Faces
	// ************************************************************************ //	
	
	/**
	 * 
	 */
	private function parseFaces():Void
	{
		var indices:String;
		
		for( meshPart in this.input.elementsNamed( "MeshPart" ) )
		{
			for( element in meshPart.elementsNamed( "indices" ) )			
			{
				indices = element.firstChild().toString();
				break;
			}
		}
		
		// ------------- //
		
		var data:Array<Int> = new Array<Int>();
		var splitted:Array<String> = indices.split(" ");
		
		for( i in 0...splitted.length )
		{
			var spl:String = splitted[i];
			
			if( spl.length == 0 || spl == "/s" )
				continue;
			
			data.push( Std.parseInt( spl ) );
		}
		
		this.setFaceData(data);
	}
	
	/**
	 * 
	 * @param	fdata
	 */
	private function setFaceData( fdata:Array<Int> ):Void 
	{
		var signature:MeshSignature = this.result.data.signature;
		
		for( f in 0...signature.numFaces)
		{			
			var start:Int = f * 3;
			var end:Int = start + 3;
			
			this.result.data.setFaceIndices( f, fdata.slice( start, end ) );			
		}		
	}	
	
}