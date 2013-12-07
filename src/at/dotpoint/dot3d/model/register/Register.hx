package at.dotpoint.dot3d.model.register;

import hxsl.Data;
/**
 * ...
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
	 * light collections: format is faked and unusable
	 */
	public static var LIGHT_COLLECTION:RegisterType = new RegisterType( "lights", VarType.TNull );
	
	// --------------------------------------------------- //
	// --------------------------------------------------- //
	
	public static var VERTEX_POSITION:RegisterType 		= new RegisterType( "pos", 				VarType.TFloat3, 0 );
	public static var VERTEX_NORMAL:RegisterType 		= new RegisterType( "normal", 			VarType.TFloat3, 1 );
	public static var VERTEX_UV:RegisterType 			= new RegisterType( "uv", 				VarType.TFloat2, 2 );
	public static var VERTEX_BARYCENTRIC:RegisterType 	= new RegisterType( "barycentric", 		VarType.TFloat3,  3 ); // wireframe
	
	// --------------------------------------------------- //
	// --------------------------------------------------- //
	// Light	
	
	//private static var FORMAT_FIELD_DIRECTION 	= { name:"direction", 	type:VarType.TFloat3 };
	//private static var FORMAT_FIELD_POSITION 		= { name:"position", 	type:VarType.TFloat3 };	
	//private static var FORMAT_FIELD_COLOR 		= { name:"color", 		type:VarType.TFloat3 };
	//
	//public static var FORMAT_LIGHT_AMBIENT:VarType 	= VarType.TObject( [ FORMAT_FIELD_COLOR ] );
	//public static var FORMAT_LIGHT_DIRECT:VarType 	= VarType.TObject( [ FORMAT_FIELD_DIRECTION,	FORMAT_FIELD_COLOR ] );
	//public static var FORMAT_LIGHT_SPOT:VarType 	= VarType.TObject( [ FORMAT_FIELD_POSITION, 	FORMAT_FIELD_DIRECTION, FORMAT_FIELD_COLOR ] );
	//public static var FORMAT_LIGHT_OMNI:VarType 	= VarType.TObject( [ FORMAT_FIELD_POSITION, 	FORMAT_FIELD_COLOR ] );
	//
	///**
	 //* generates a Light-Collection VarType for the given LightSpecification
	 //*/
	//public static function getFormatLightCollection( specification:LightSpecification ):VarType
	//{
		//var directList:VarType 	= VarType.TArray( FORMAT_LIGHT_DIRECT, 	specification.maxDirect );
		//var spotList:VarType 	= VarType.TArray( FORMAT_LIGHT_SPOT, 	specification.maxSpot );		
		//var omniList:VarType 	= VarType.TArray( FORMAT_LIGHT_OMNI, 	specification.maxOmni );		
		//
		//var ambient = { name:"ambient", type:FORMAT_LIGHT_AMBIENT 	};
		//var direct 	= { name:"direct", 	type:directList  			};
		//var spot 	= { name:"spot", 	type:spotList 				};
		//var omni 	= { name:"omni", 	type:omniList 				};
		//
		//return VarType.TObject( [ ambient, direct, spot, omni ] );
	//}
	
}