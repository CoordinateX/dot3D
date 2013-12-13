package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.EditableMesh;
import at.dotpoint.dot3d.model.mesh.MeshSignature;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class Line extends EditableMesh
{

	private var previous:Vector3;
	private var numSet:Int;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //
	
	public function new( segments:Int ) 
	{
		var numVertices:Int = 5 * segments;
		var numFaces:Int 	= 2 * segments;		
		var numRegister:Int = 3;		
		
		var numUniquePos:Int   = segments + 1;
		var numUniqueDirs:Int  = segments + 1;		
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
		
		this.startVertexData( Register.VERTEX_COLOR );
		
		var sr:Float = Math.random() * 0.9;
		var sg:Float = Math.random() * 0.4;
		var sb:Float = Math.random() * 0.5;
		
		for( s in 0...(segments + 1) )
		{
			var step:Float = 1 -( s / segments );
			
			var r:Float = 0.1 + sr + step * (2-sr);
			var g:Float = 0.1 + sg + step * (2-sg);
			var b:Float = 0.1 + sb + step * (2-sb);

			this.addVertexData( [r, g, b] );  
		}
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //
	
	public function line( pos:Array<Float> ):Void
	{
		if( this.numSet * 2 > this.data.signature.numFaces )
			throw "already set max amount of segments";
		
		this.addVertexData( pos, Register.VERTEX_POSITION );
		this.addVertexData( pos, Register.VERTEX_DIRECTION  );
		
		// -------------- //
		
		if( this.previous != null )
		{
			/*
			var direction:Vector3 = new Vector3( pos[0], pos[1], pos[2] );
				direction = Vector3.subtract( direction, this.previous, direction );
				direction.normalize();
			
			this.addVertexData( direction.toArray(), Register.VERTEX_DIRECTION  );
			*/
			// ----------------------- //
			
			var c:Int = this.numSet;
			var p:Int = this.numSet - 1;			
			
			//this.createFace( [p,p,0,p, c,p,0,c, c,p,1,c] );	// pos, dir, sign, color	
			//this.createFace( [c,p,1,c, p,p,1,p, p,p,0,p] );
			
			this.createFace( [p,c,1,p, c,p,0,c, c,p,1,c] );	// pos, dir, sign, color	
			this.createFace( [c,p,1,c, p,c,1,p, p,c,0,p] );
		}
		
		// -------------- //
		
		this.previous = new Vector3( pos[0], pos[1], pos[2] );
		this.numSet++;
	}
}