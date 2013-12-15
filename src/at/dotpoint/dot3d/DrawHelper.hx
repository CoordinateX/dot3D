package at.dotpoint.dot3d;

import at.dotpoint.dot3d.shader.LineShader;
import at.dotpoint.dot3d.model.Model;
import at.dotpoint.dot3d.primitives.Line;


/**
 * ...
 * @author RK
 */
class DrawHelper
{

	public static function createAxis( size:Float, thickness:Float = 2 ):Model
	{
		var s:Float = size;
		
		var mesh:Line = new Line( 3, 3 );
			mesh.moveTo( [0, 0, 0], [1,0,0] );
			mesh.lineTo( [s, 0, 0], [1,0,0] );
			
			mesh.moveTo( [0, 0, 0], [0,1,0] );
			mesh.lineTo( [0, s, 0], [0,1,0] );
			
			mesh.moveTo( [0, 0, 0], [0,0,1] );
			mesh.lineTo( [0, 0, s], [0,0,1] );
			
		var shader:LineShader = new LineShader();
			shader.thickness = thickness;		
			
		return new Model( mesh, shader ); 
	}
	
}