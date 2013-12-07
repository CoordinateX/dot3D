package at.dotpoint.dot3d.model.mesh;

import at.dotpoint.math.Vector3;
import at.dotpoint.dot3d.model.register.Register;
import haxe.ds.Vector;

/**
 * ...
 * @author Gerald Hattensauer
 */
class TriangleFace
{

	public var vertices:Vector<Vertex>;
	public var index:Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( index:Int ) 
	{
		this.index = index;
		this.vertices = new Vector<Vertex>( 3 );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * not normalized normal of the face
	 * @return
	 */
	public function getNormal( output:Vector3 ):Vector3
	{
		var p1:Vector3 = this.getPosition( 0 );
		var p2:Vector3 = this.getPosition( 1 );
		var p3:Vector3 = this.getPosition( 2 );
		
		var sub1:Vector3 = cast Vector3.subtract( p2, p1, new Vector3() );
		var sub2:Vector3 = cast Vector3.subtract( p3, p1, new Vector3() );
		
		return cast Vector3.cross( sub1, sub2, output );
	}

	/**
	 * "copy" not a reference to the vertex
	 */
	public function getPosition( index:Int ):Vector3
	{
		var vertex:Vertex = this.vertices[ index ];		
		var raw:Array<Float> = vertex.getData( Register.VERTEX_POSITION ); 
		
		return new Vector3( raw[0], raw[1], raw[2] );
	}	

}