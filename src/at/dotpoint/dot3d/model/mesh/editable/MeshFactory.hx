package at.dotpoint.dot3d.model.mesh.editable;

import at.dotpoint.dot3d.model.register.RegisterType;
import at.dotpoint.math.MathUtil;
import at.dotpoint.dot3d.model.register.Register;
import at.dotpoint.dot3d.model.register.RegisterType;
import haxe.ds.StringMap;

/**
 * Helper with usefull methodes to quickly create a mesh without any file import and parsing.<br/>
 * Has a few additional internal data structures that ensure to conserve data usage so only unique
 * data is stored (e.g. to avoid duplicate vertex positions )
 *
 * @author RK
 */
class MeshFactory
{

	/**
	 * unique register data for each RegisterType
	 */
	private var indexLookup:StringMap<StringMap<Int>>;

	/**
	 * unique indices pointing to unique RegisterData for each RegisterType
	 */
	private var registerData:StringMap<Array<Array<Float>>>;

	/**
	 * Vertices composed of indices pointing to RegisterData
	 */
	private var indexData:Array<Array<Int>>;

	/**
	 * Triangle: 3 indices pointing to different IndexData
	 */
	private var faceIndices:Array<Array<Int>>;

	// -------------- //

	/**
	 *
	 */
	public var numRegisters(default,null):Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	/**
	 *
	 */
	public function new()
	{
		this.reset();
	}

	public function reset():Void
	{
		this.indexLookup  = new StringMap<StringMap<Int>>();
		this.registerData = new StringMap<Array<Array<Float>>>();
		this.indexData	  = new Array<Array<Int>>();
		this.faceIndices  = new Array<Array<Int>>();

		this.numRegisters = -1;
	}

	// ************************************************************************ //
	// building (mesh)
	// ************************************************************************ //

	/**
	 *
	 */
	public function buildMesh():Mesh
	{
		var signature:MeshSignature = this.buildMeshSignature();

		var mesh:Mesh = new Mesh( signature );

		// --------------------- //
		// registerData:

		var registers:Array<RegisterType> = signature.toArray();

		for( type in registers )
		{
			var data:Array<Array<Float>> = this.getRegisterData( type );

			for( j in 0...data.length )
				mesh.data.setVertexData( type, j, data[j] );
		}

		// --------------------- //
		// registerIndices:

		for( j in 0...signature.numVertices )
		{
			mesh.data.setVertexIndices( j, this.indexData[j] );
		}

		// --------------------- //
		// faceIndices:

		for( i in 0...signature.numFaces )
		{
			mesh.data.setFaceIndices( i, this.faceIndices[i] );
		}

		// --------------------- //

		return mesh;
	}

	/**
	 *
	 */
	public function buildMeshSignature():MeshSignature
	{
		var numV:Int = this.indexData.length;
		var numF:Int = this.faceIndices.length;
		var numR:Int = this.numRegisters;

		var signature:MeshSignature = new MeshSignature( numV, numF, numR );

		for( type in this.indexLookup.keys() )
		{
			if( type == Register.INDEX.ID )
				continue;

			var register:RegisterType = Register.getRegisterType( type );

			if( register == null )
				throw "unknown register " + type;

			signature.addType( register, this.registerData.get( type ).length );
		}

		return signature;
	}

	// ************************************************************************ //
	// face/triangles
	// ************************************************************************ //

	/**
	 *
	 */
	public function addFaceIndices( indices:Array<Int> ):Int
	{
		if( !this.validateFaceIndices( indices ) )
			return -1;

		var size:Int 	= this.numRegisters;
		var length:Int 	= indices.length;

		// ----------- //

		var face:Array<Int> = new Array<Int>();

		for( v in 0...3 )
		{
			var start:Int = v * size;
			var vertex:Array<Int> = indices.slice( start, start + size );

			face[v] = this.addVertexIndices( vertex );
		}

		return this.faceIndices.push( face ) - 1;
	}

	/**
	 *
	 */
	public function addVertexIndices( vertex:Array<Int> ):Int
	{
		var fIndex:Int = this.getRegisterIndex( vertex, Register.INDEX );

		if( fIndex == - 1 )
			fIndex = this.setIndexData( vertex, fIndex ) - 1;

		return fIndex;
	}

	/**
	 *
	 */
	public function setIndexData( data:Array<Int>, index:Int ):Int
	{
		var lookup:StringMap<Int>   = this.getLookup( Register.INDEX );
		var list:Array<Int>         = this.indexData[index];

		if( list == null )
			index = this.indexData.length;

		this.indexData[index] = data;
		lookup.set( this.getLookupSignature(data), index );

		return this.indexData.length;
	}

	/**
	 *
	 */
	private function validateFaceIndices( face:Array<Int> ):Bool
	{
		var fRegisters:Float = face.length / 3;
		var iRegisters:Int = Math.round( fRegisters );

		if( !MathUtil.isEqual( fRegisters, iRegisters ) && iRegisters > 0 )
			throw "face indices must be a multiple of 3 (exactly 3 vertex tuple)";

		if( this.numRegisters == -1 )
			this.numRegisters = iRegisters;

		if( iRegisters != this.numRegisters )
			throw "all faces must have the same amount of tuple components (all registerData indices must be set)";

		return true;
	}

	// ************************************************************************ //
	// register/vertex data
	// ************************************************************************ //

	/**
	 *
	 */
	public function addRegisterData( data:Array<Float>, type:RegisterType ):Int
	{
		if( data.length != type.size )
			throw "provided register data must have exactly " + type.size + " entries but " + data.length + " provided";

		var index:Int = this.getRegisterIndex( data, type );

		if( index == -1 )
			index = this.setRegisterData( data, type, index ) - 1;

		return index;
	}

	/**
	 *
	 */
	public function setRegisterData( data:Array<Float>, type:RegisterType, index:Int ):Int
	{
		var lookup:StringMap<Int>    = this.getLookup( type );
		var list:Array<Array<Float>> = this.getRegisterData( type );

		if( index == - 1)
			index = list.length;

		list[index] = data;
		lookup.set( this.getLookupSignature(data), index );

		return list.length;
	}

	// ************************************************************************ //
	// lookup
	// ************************************************************************ //

	/**
	 *
	 */
	private function getLookup( type:RegisterType ):StringMap<Int>
	{
		if( !this.indexLookup.exists( type.ID ) )
			this.indexLookup.set(  type.ID, new StringMap<Int>() );

		return this.indexLookup.get( type.ID );
	}

	/**
	 *
	 */
	private function getRegisterData( type:RegisterType ):Array<Array<Float>>
	{
		if( !this.registerData.exists( type.ID ) )
			 this.registerData.set( type.ID, new Array<Array<Float>>() );

		return this.registerData.get( type.ID );
	}

	/**
	 *
	 */
	public function getRegisterIndex( data:Array<Dynamic>, type:RegisterType ):Int
	{
		var lookup:StringMap<Int> 	= this.getLookup( type );
		var signature:String 		= this.getLookupSignature( data );

		if( lookup.exists( signature ) )	// data not unique, already stored
		{
			return lookup.get( signature );	// index to stored data
		}

		return -1;
	}

	/**
	 *
	 */
	inline private function getLookupSignature( data:Array<Dynamic> ):String
	{
		return data.join("_");
	}

	/**
	 *
	 */
	public function getCurrentRegisterTypes():Array<RegisterType>
	{
		var types:Array<RegisterType> = new Array<RegisterType>();

		for( type in this.indexLookup.keys() )
		{
			if( type == Register.INDEX.ID )
				continue;

			var register:RegisterType = Register.getRegisterType( type );

			if( register == null )
				throw "unknown register " + type;

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
}