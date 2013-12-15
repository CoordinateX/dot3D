package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.EditableMesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.math.vector.Vector3;

/**
 * a set of lines can be created using this class. the amount of segments (connected lines) and sets (disjointed lines)
 * must be specified first in the constructor. afterwards you can use moveTo and lineTo to create the mesh. has to be
 * plugged into a model aswell and requires the LineShader to work.
 * 
 * @author RK
 */
class Line extends EditableMesh
{

	private var previous:Vector3;
	private var numDrawn:Int;
	
	private var numSegments:Int;
	private var numSets:Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( segments:Int, sets:Int = 1 ) 
	{
		this.numSegments = segments;
		this.numSets = sets;
		
		var numVertices:Int = 5 * segments; // one of the 4 has to have a different sign
		var numFaces:Int 	= 2 * segments;		
		var numRegister:Int = 3;		
		
		var numUniquePos:Int   = segments + sets;
		var numUniqueDirs:Int  = segments + sets;		
		var numUniqueSigns:Int = 2;				// 1, -1
		
		var signature:MeshSignature = new MeshSignature( numVertices, numFaces, numRegister );		
			signature.addType( Register.VERTEX_POSITION, numUniquePos ); 
			signature.addType( Register.VERTEX_DIRECTION, numUniqueDirs ); 
			signature.addType( Register.VERTEX_SIGN, numUniqueSigns ); 
			signature.addType( Register.VERTEX_COLOR, numUniquePos ); 
			
		super( signature );
		
		this.init( segments );
	}
	
	private function init( segments:Int ):Void
	{
		this.addVertexData( [ 0.5], Register.VERTEX_SIGN  );
		this.addVertexData( [-0.5], Register.VERTEX_SIGN );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	/**
	 * start a new set without drawing a line similar to flash.graphics.moveTo
	 * position must be 3 values (x,y,z) and color aswell (r,g,b)
	 */
	public function moveTo( pos:Array<Float>, color:Array<Float> ):Void
	{
		this.previous = new Vector3( pos[0], pos[1], pos[2] );	
		
		this.addVertexData( pos, Register.VERTEX_POSITION 	);
		this.addVertexData( pos, Register.VERTEX_DIRECTION  );		// could link to pos? ... 
		this.addVertexData( color, Register.VERTEX_COLOR 	);		// could check if unique ... 
		
		this.numDrawn++;
	}
	
	/**
	 * creates a line from the previous position to the given one similar to flash.graphics.lineTo
	 * position must be 3 values (x,y,z) and color aswell (r,g,b)
	 */
	public function lineTo( pos:Array<Float>, color:Array<Float> ):Void
	{
		if( (this.numDrawn-this.numSets) * 2 > this.data.signature.numFaces )
			throw "already set max amount of segments";
			
		if( this.previous == null )
			throw "must call moveTo first";
		
		// -------------- //
		
		var c:Int = this.numDrawn;
		var p:Int = this.numDrawn - 1;			
		
		this.createFace( [p,c,1,p, c,p,0,c, c,p,1,c] );	// pos, dir, sign, color	
		this.createFace( [c,p,1,c, p,c,1,p, p,c,0,p] );		
		
		// -------------- //
		
		this.moveTo( pos, color );
	}
}