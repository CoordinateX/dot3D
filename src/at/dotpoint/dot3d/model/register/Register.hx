package at.dotpoint.dot3d.model.register;

import hxsl.Data;
/**
 * List of avaible RegisterType each acting somewhat like an enum augmented with additional data.
 * RegisterTypes are used for vertex data aswell as materials/shaders. Each type must specify
 * a priority as it defines the order in which it is stored and possible accessed.
 * 
 * @author Gerald Hattensauer
 */
class Register
{

	/**
	 * model 2 world transformation matrix
	 */
	public static var MODEL_WORLD:RegisterType 		= new RegisterType( "mpos", VarType.TMatrix(4, 4, null) );
	
	/**
	 * world 2 camera transformation matrix
	 */
	public static var WORLD_CAMERA:RegisterType 	= new RegisterType( "mproj", VarType.TMatrix(4, 4, null) );	
	
	/**
	 * a single light (will be changed)
	 */
	public static var LIGHT:RegisterType 			= new RegisterType( "light", VarType.TFloat3 );
	
	/**
	 * 
	 */
	public static var CAMERA_POSITION:RegisterType 	= new RegisterType( "cam", VarType.TFloat3 );
	
	// --------------------------------------------------- //
	// --------------------------------------------------- //
	
	public static var VERTEX_POSITION:RegisterType 		= new RegisterType( "pos", 			VarType.TFloat3, 0 );
	public static var VERTEX_NORMAL:RegisterType 		= new RegisterType( "normal", 		VarType.TFloat3, 2 );
	public static var VERTEX_UV:RegisterType 			= new RegisterType( "uv", 			VarType.TFloat2, 1 );
	public static var VERTEX_BARYCENTRIC:RegisterType 	= new RegisterType( "barycentric", 	VarType.TFloat3, 3 ); // wireframe
	
	// especially for lines/particles
	public static var VERTEX_DIRECTION:RegisterType 	= new RegisterType( "dir", 			VarType.TFloat3, 1 );
	public static var VERTEX_SIGN:RegisterType 			= new RegisterType( "sign", 		VarType.TFloat,  2 );
	public static var VERTEX_COLOR:RegisterType 		= new RegisterType( "color", 		VarType.TFloat3, 3 );

	// --------------------------------------------------- //
	// --------------------------------------------------- //

	public static var INDEX:RegisterType 				= new RegisterType( "index", 		VarType.TInt, 	-1 );

	// --------------------------------------------------- //
	// --------------------------------------------------- //

	/**
	 *
	 */
	public static function getRegisterType( id:String ):RegisterType
	{
		var list:Array<RegisterType> = [VERTEX_POSITION,VERTEX_NORMAL,VERTEX_UV,VERTEX_BARYCENTRIC,VERTEX_COLOR,VERTEX_DIRECTION,VERTEX_SIGN];

		for( type in list )
		{
			if( type != null && type.ID == id )
				return type;
		}

		return null;
	}
	
}