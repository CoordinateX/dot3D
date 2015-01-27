package at.dotpoint.dot3d.primitives;

import at.dotpoint.dot3d.model.mesh.editable.CustomMesh;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.math.vector.Vector3;

/**
 * a set of lines can be created using this class. the amount of segments (connected lines) and sets (disjointed lines)
 * must be specified first in the constructor. afterwards you can use moveTo and lineTo to create the mesh. has to be
 * plugged into a model aswell and requires the LineShader to work.
 * 
 * @author RK
 */
class Line extends CustomMesh
{

	private var current:Array<Int>;
	private var previous:Array<Int>;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	/**
	 *
	 */
	public function new()
	{
		super();

		this.addRegisterData( [ 0.5], Register.VERTEX_SIGN );
		this.addRegisterData( [-0.5], Register.VERTEX_SIGN );
	}
	
	// ************************************************************************ //
	// Methodes
	// ************************************************************************ //

	public function moveToVector( pos:Vector3, color:Vector3 ):Void
	{
		this.moveTo( [pos.x, pos.y, pos.z], [color.x, color.y, color.z] );
	}

	public function lineToVector( pos:Vector3, color:Vector3 ):Void
	{
		this.lineTo( [pos.x, pos.y, pos.z], [color.x, color.y, color.z] );
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
		if( this.current == null )
			this.current = new Array<Int>();

		if( this.previous == null )
			this.previous = new Array<Int>();

		// ------------------- //

		this.addLine( pos, color, this.previous );
	}
	
	/**
	 * creates a line from the previous position to the given one similar to flash.graphics.lineTo
	 * position must be 3 values (x,y,z) and color aswell (r,g,b)
	 */
	public function lineTo( pos:Array<Float>, color:Array<Float> ):Void
	{
		if( this.previous == null )
			throw "must call moveTo first";

		this.addLine( pos, color, this.current );

		// -------------- //

		var pP:Int = this.previous[0];	// previous pos
		var pD:Int = this.previous[1];  // previous dir
		var pC:Int = this.previous[2];  // previous color

		var cP:Int = this.current[0];	// current pos
		var cD:Int = this.current[1];   // current dir
		var cC:Int = this.current[2];   // current color

		this.addFaceIndices( [pP,cD,1,pC, cP,pD,0,cC, cP,pD,1,cC] );	// pos, dir, sign, color
		this.addFaceIndices( [cP,pD,1,cC, pP,cD,1,pC, pP,cD,0,pC] );
		
		// -------------- //
		
		this.swap();
	}

	/**
	 *
	 */
	private function addLine( pos:Array<Float>, color:Array<Float>, data:Array<Int> ):Void
	{
		data[0] = this.addRegisterData( pos,   Register.VERTEX_POSITION 	);
		data[1] = this.addRegisterData( pos,   Register.VERTEX_DIRECTION    );
		data[2] = this.addRegisterData( color, Register.VERTEX_COLOR 	    );
	}

	/**
	 *
	 */
	private function swap():Void
	{
		var temporary:Array<Int> = this.current;

		this.current  = this.previous;
		this.previous = temporary;
	}

}