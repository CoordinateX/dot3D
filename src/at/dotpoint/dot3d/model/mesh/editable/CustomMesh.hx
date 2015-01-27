package at.dotpoint.dot3d.model.mesh.editable;

import at.dotpoint.dot3d.model.register.Register;
import Array;
import at.dotpoint.math.vector.Vector2;
import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.math.vector.Vector3;

class CustomMesh extends MeshFactory
{

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();
	}

	// ************************************************************************ //
	// Operations
	// ************************************************************************ //

	/**
	 *
	 */
	public function recalculateNormals( combine:Bool = true ):Void
	{
		var triangles:Array<MeshTriangle> = this.getTriangleList();

		// ------------- //

		for( tri in triangles )
		{
			var normal:Vector3 = tri.calculatetNormal();

			for( v in 0...3 )
			{
				tri.getVertex( v ).normal = normal;
			}
		}

		// ------------- //

		if( combine )
		{
			var normals:Array<Vector3> = new Array<Vector3>();

			for( tri in triangles )
			{
				for( v in 0...3 )
				{
					var vertex:MeshVertex = tri.getVertex( v );
					var index:Int = vertex.getRegisterIndex( Register.VERTEX_POSITION );

					if( normals[index] == null )    normals[index] = vertex.normal;
					else					        normals[index] = Vector3.add( vertex.normal, normals[index], normals[index] );
				}
			}

			for( tri in triangles )
			{
				for( v in 0...3 )
				{
					var vertex:MeshVertex = tri.getVertex( v );
					var index:Int = vertex.getRegisterIndex( Register.VERTEX_POSITION );

					normals[index].normalize();
					vertex.normal = normals[index];
				}
			}
		}

		// ------------- //

		this.reset();
		this.addTriangleList( triangles );
	}

	// ************************************************************************ //
	// Vector2/3
	// ************************************************************************ //

	/**
	 *
	 */
	public function addVector3( vertex:Vector3, type:RegisterType ):Int
	{
		if( type.size != 3 )
			throw "given RegisterType must support exactly 3 components";

		return this.addRegisterData( [vertex.x, vertex.y, vertex.z], type );
	}

	/**
	 *
	 */
	public function getVector3( index:Int, type:RegisterType ):Vector3
	{
		if( type.size != 3 )
			throw "given RegisterType must support exactly 3 components";

		if( this.registerData.exists( type.ID ) )
		{
			var data:Array<Float> = this.registerData.get( type.ID )[index];

			if( data == null )
				throw "index " + index + " is not a valid registerIndex";

			var vector:Vector3 = new Vector3();
				vector.x = data[0];
				vector.y = data[1];
				vector.z = data[2];

			return vector;
		}

		return null;
	}

	/**
	 *
	 */
	public function getVectorList3( type:RegisterType ):Array<Vector3>
	{
		if( !this.registerData.exists( type.ID ) )
			return null;

		var length:Int = this.registerData.get( type.ID ).length;
		var list:Array<Vector3> = new Array<Vector3>();

		for( j in 0...length )
		{
			list[j] = this.getVector3( j, type );
		}

		return list;
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //

	/**
	 *
	 */
	public function addVector2( vertex:Vector2, type:RegisterType ):Int
	{
		if( type.size != 2 )
			throw "given RegisterType must support exactly 2 components";

		return this.addRegisterData( [vertex.x, vertex.y], type );
	}

	/**
	 *
	 */
	public function getVector2( index:Int, type:RegisterType ):Vector2
	{
		if( type.size != 2 )
			throw "given RegisterType must support exactly 2 components";

		if( this.registerData.exists( type.ID ) )
		{
			var data:Array<Float> = this.registerData.get( type.ID )[index];

			if( data == null )
				throw "index " + index + " is not a valid registerIndex";

			var vector:Vector2 = new Vector2();
				vector.x = data[0];
				vector.y = data[1];

			return vector;
		}

		return null;
	}

	/**
	 *
	 */
	public function getVectorList2( type:RegisterType ):Array<Vector2>
	{
		if( !this.registerData.exists( type.ID ) )
			return null;

		var length:Int = this.registerData.get( type.ID ).length;
		var list:Array<Vector2> = new Array<Vector2>();

		for( j in 0...length )
		{
			list[j] = this.getVector2( j, type );
		}

		return list;
	}

	// ************************************************************************ //
	// Triangle / Vertex
	// ************************************************************************ //

	/**
	 *
	 */
	public function getTriangleList():Array<MeshTriangle>
	{
		var list:Array<MeshTriangle> = new Array<MeshTriangle>();

		for( f in 0...this.faceIndices.length )
		{
			list[f] = this.getTriangle( f );
		}

		return list;
	}

	/**
	 *
	 */
	public function addTriangleList( triangles:Array<MeshTriangle> ):Array<Int>
	{
		var list:Array<Int> = new Array<Int>();

		for( f in 0...triangles.length )
		{
			list[f] = this.addTriangle( triangles[f] );
		}

		return list;
	}

	/**
	 *
	 */
	public function getTriangle( index:Int ):MeshTriangle
	{
		var face:Array<Int> = this.faceIndices[index];

		if( face == null )
			throw "index " + index + " is not a valid faceIndex";

		var triangle:MeshTriangle = new MeshTriangle();
			triangle.v1 = this.getVertex( face[0] );
			triangle.v2 = this.getVertex( face[1] );
			triangle.v3 = this.getVertex( face[2] );
			triangle.index = index;

		return triangle;
	}

	/**
	 *
	 */
	public function addTriangle( triangle:MeshTriangle ):Int
	{
		var face:Array<Int> = new Array<Int>();
			face[0] = this.addVertex( triangle.v1 );
			face[1] = this.addVertex( triangle.v2 );
			face[2] = this.addVertex( triangle.v3 );

		if( this.numRegisters == -1 )
			this.numRegisters = this.getCurrentRegisterTypes().length;

		return this.faceIndices.push( face ) - 1;
	}

	// ----------------------------------------------------------------------- //
	// ----------------------------------------------------------------------- //

	/**
	 *
	 */
	public function getVertexList():Array<MeshVertex>
	{
		var list:Array<MeshVertex> = new Array<MeshVertex>();

		for( j in 0...this.indexData.length )
		{
			list[j] = this.getVertex( j );
		}

		return list;
	}

	/**
	 *
	 */
	public function addVertexList( vertices:Array<MeshVertex> ):Array<Int>
	{
		var list:Array<Int> = new Array<Int>();

		for( v in 0...vertices.length )
		{
			list[v] = this.addVertex( vertices[v] );
		}

		return list;
	}

	/**
	 *
	 */
	public function getVertex( index:Int ):MeshVertex
	{
		var registers:Array<Int> = this.indexData[index];

		if( registers == null )
			throw "index " + index + " is not a valid registerIndex";

		// ------------- //

		var registerTypes:Array<RegisterType> = this.getCurrentRegisterTypes();

		if( registerTypes.length != registers.length )
			throw "registerIndices do not match current amount of registers set";

		// ------------- //

		var vertex:MeshVertex = new MeshVertex( null );
			vertex.index = index;

		for( j in 0...registerTypes.length )
		{
			var type:RegisterType = registerTypes[j];
			var data:Array<Float> = this.getRegisterData( type )[ registers[j] ];

			if( data == null )
				throw "could not find " + type.ID + " data for index: " + registers[j];

			vertex.setRegisterData( data, type );
			vertex.setRegisterIndex( registers[j], type );
		}

		// ------------- //

		return vertex;
	}

	/**
	 *
	 */
	public function addVertex( vertex:MeshVertex ):Int
	{
		var registers:Array<RegisterType> = vertex.getCurrentRegisterTypes();
		var current:Array<RegisterType> = this.getCurrentRegisterTypes();

		if( registers.length != current.length && current.length > 0 )
			throw "vertex registerData does not match current registers";

		// ------------- //

		var vIndices:Array<Int> = new Array<Int>();

		for( j in 0...registers.length )
		{
			var type:RegisterType = registers[j];
			var data:Array<Float> = vertex.getRegisterData( type );

			vIndices[j] = this.addRegisterData( data, type );
		}

		return this.addVertexIndices( vIndices );
	}


}
