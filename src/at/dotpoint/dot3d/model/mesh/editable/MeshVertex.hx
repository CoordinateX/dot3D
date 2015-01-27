package at.dotpoint.dot3d.model.mesh.editable;

import at.dotpoint.math.vector.Vector3;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.math.vector.Vector2;
import at.dotpoint.math.vector.Vector3;

class MeshVertex
{

	/**
	 *
	 */
	public var registerData:Array<{type:RegisterType, data:Array<Float>}>;
	public var registerIndices:Array<{type:RegisterType, data:Int}>;

	/**
	 *
	 */
	public var index:Int;

	// ------------------------- /

	/**
	 *
	 */
	public var position(get,set):Vector3;

	/**
	 *
	 */
	public var normal(get,set):Vector3;

	/**
	 *
	 */
	public var color(get,set):Vector3;

	/**
	 *
	 */
	public var uv(get,set):Vector2;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new(  position:Vector3, ?normal:Vector3, ?uv:Vector2, ?color:Vector3 )
	{
		this.registerData    = new Array<{type:RegisterType, data:Array<Float>}>();
		this.registerIndices = new Array<{type:RegisterType, data:Int}>();

		this.position 	= position;
		this.normal 	= normal;
		this.uv 		= uv;
		this.color 		= color;
	}

	// ************************************************************************ //
	// RegisterData/Indices
	// ************************************************************************ ///**

	/**
	 *
	 */
	public function getRegisterData( type:RegisterType ):Array<Float>
	{
		for( register in this.registerData )
		{
			if( register.type == type )
				return cast register.data;
		}

		return null;
	}

	public function setRegisterData( data:Array<Float>, type:RegisterType ):Void
	{
		for( register in this.registerData )
		{
			if( register.type == type )
			{
				register.data = data;
				return;
			}
		}

		if( data != null )
			this.registerData.push( {type:type, data:data} );
	}

	/**
	 *
	 */
	public function getRegisterIndex( type:RegisterType ):Int
	{
		for( register in this.registerIndices )
		{
			if( register.type == type )
				return cast register.data;
		}

		return -1;
	}

	public function setRegisterIndex( data:Int, type:RegisterType ):Void
	{
		for( register in this.registerIndices )
		{
			if( register.type == type )
			{
				register.data = data;
				return;
			}
		}

		if( data != -1 )
			this.registerIndices.push( {type:type, data:data} );
	}

	// ************************************************************************ //
	// getter / setter
	// ************************************************************************ //

	/**
	 * VERTEX_POSITION
	 */
	private function get_position():Vector3
	{
		return this.getVector3( Register.VERTEX_POSITION );
	}

	private function set_position( vector:Vector3 ):Vector3
	{
		return this.setVector3( vector, Register.VERTEX_POSITION );
	}

	/**
	 * VERTEX_NORMAL
	 */
	private function get_normal():Vector3
	{
		return this.getVector3( Register.VERTEX_NORMAL );
	}

	private function set_normal( vector:Vector3 ):Vector3
	{
		return this.setVector3( vector, Register.VERTEX_NORMAL );
	}

	/**
	 * VERTEX_COLOR
	 */
	private function get_color():Vector3
	{
		return this.getVector3( Register.VERTEX_COLOR );
	}

	private function set_color( vector:Vector3 ):Vector3
	{
		return this.setVector3( vector, Register.VERTEX_COLOR );
	}

	/**
	 * VERTEX_UV
	 */
	private function get_uv():Vector2
	{
		return this.getVector2( Register.VERTEX_UV );
	}

	private function set_uv( vector:Vector2 ):Vector2
	{
		return this.setVector2( vector, Register.VERTEX_UV );
	}

	// ************************************************************************ //
	// Vector2/3
	// ************************************************************************ //

	/**
	 *
	 */
	public function getVector3( type:RegisterType ):Vector3
	{
		if( type.size != 3 )
			throw "given RegisterType must support exactly 3 components";

		var data:Array<Float> = this.getRegisterData( type );

		if( data == null )
			return null;

		var vector:Vector3 = new Vector3();
			vector.x = data[0];
			vector.y = data[1];
			vector.z = data[2];

		return vector;
	}

	/**
	 *
	 */
	public function setVector3( vector:Vector3, type:RegisterType ):Vector3
	{
		if( type.size != 3 )
			throw "given RegisterType must support exactly 3 components";

		if( vector == null )
		{
			this.setRegisterData( null, type );
			return null;
		}
		else
		{
			var data:Array<Float> = new Array<Float>();
				data[0] = vector.x;
				data[1] = vector.y;
				data[2] = vector.z;

			this.setRegisterData( data, type );

			return vector;
		}
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //

	/**
	 *
	 */
	public function getVector2( type:RegisterType ):Vector2
	{
		if( type.size != 2 )
			throw "given RegisterType must support exactly 2 components";

		var data:Array<Float> = this.getRegisterData( type );

		if( data == null )
			return null;

		var vector:Vector2 = new Vector2();
			vector.x = data[0];
			vector.y = data[1];

		return vector;

	}

	/**
	 *
	 */
	public function setVector2( vector:Vector2, type:RegisterType ):Vector2
	{
		if( type.size != 2 )
			throw "given RegisterType must support exactly 2 components";

		if( vector == null )
		{
			this.setRegisterData( null, type );
			return null;
		}
		else
		{
			var data:Array<Float> = new Array<Float>();
				data[0] = vector.x;
				data[1] = vector.y;

			this.setRegisterData( data, type );

			return vector;
		}
	}

	// ************************************************************************ //
	// Helper
	// ************************************************************************ //

	/**
	 *
	 */
	public function getCurrentRegisterTypes():Array<RegisterType>
	{
		var types:Array<RegisterType> = new Array<RegisterType>();

		for( data in this.registerData )
		{
			var register:RegisterType = data.type;

			if( register == null )
				throw "unknown register " + data.type;

			types.push( register );
		}

		// ------------------ //

		function sort( a:RegisterType, b:RegisterType ):Int
		{
			return a.priority - b.priority;
		}

		types.sort( sort );

		return types;
	}

	/**
	 *
	 */
	public function toString():String
	{
		return "[Vertex:" + this.position + "]";
	}

}
