package flash.at.dotpoint.dot3d.renderable.buffer;

import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import haxe.at.dotpoint.display.renderable.mesh.buffer.AMeshBuffer;
import haxe.at.dotpoint.display.renderable.mesh.data.IMeshData;
import haxe.at.dotpoint.display.renderable.mesh.data.MeshSignature;
import haxe.at.dotpoint.display.renderable.register.type.RegisterFormat;
import haxe.at.dotpoint.display.renderable.register.type.RegisterType;
import haxe.at.dotpoint.display.renderable.shader.IShader;

/**
 * ...
 * @author RK
 */
class MeshBuffer extends AMeshBuffer
{

	/**
	 *
	 */
	public var indexBuffer(default,null):IndexBuffer3D;

	/**
	 *
	 */
	public var vertexBuffer(default, null):VertexBuffer3D;

	// -------------- //

	/**
	 *
	 */
	private var context:Context3D;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( context:Context3D )
	{
		super();

		this.context = context;
	}

	// ************************************************************************ //
	// Allocate
	// ************************************************************************ //

	/**
	 * data mesh to upload to the GPU
	 */
	override public function allocate( data:IMeshData ):Void
	{
		this.dispose( data );

		// ---------- //

		if( this.vertexBuffer == null )
			this.allocateVertexBuffer( data );

		if( this.indexBuffer == null )
			this.allocateIndexBuffer( data );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 *
	 */
	private function allocateVertexBuffer( data:IMeshData ):Void
	{
		var vertices:Vector<Float> = this.createVertexBuffer( data );

		var numVertices:Int = data.signature.numVertices;
		var vertexSize:Int  = 0;

		for( type in data.signature )
			vertexSize += type.size;

		this.vertexBuffer = this.context.createVertexBuffer( numVertices, vertexSize );
		this.vertexBuffer.uploadFromVector( vertices, 0, numVertices );
	}

	/**
	 *
	 */
	private function allocateIndexBuffer( data:IMeshData ):Void
	{
		var indices:Vector<UInt> = this.createIndexBuffer( data );

		this.indexBuffer = this.context.createIndexBuffer( indices.length );
		this.indexBuffer.uploadFromVector( indices, 0, indices.length );
	}

	// ------------------------------------------------------------------------ //
	// ------------------------------------------------------------------------ //

	/**
	 * converts internal representation
	 */
	private function createIndexBuffer( data:IMeshData ):Vector<UInt>
	{
		var stream:Vector<UInt> = new Vector<UInt>( this.getIndexBufferSize( data.signature ), true );

		function setStreamData( index:Int, value:Int ):Void
		{
			stream[index] = cast value;
		}

		this.populateIndexStream( data, setStreamData );

		// -------------------- //

		return stream;
	}

	/**
	 *  converts internal representation
	 */
	public function createVertexBuffer( data:IMeshData ):Vector<Float>
	{
		var stream:Vector<Float> = new Vector<Float>( this.getVertexBufferSize( data.signature ), true );

		function setStreamData( index:Int, value:Float ):Void
		{
			stream[index] = value;
		}

		this.populateVertexStream( data, setStreamData );

		// -------------------- //

		return stream;
	}

	// ************************************************************************ //
	// dispose
	// ************************************************************************ //


	/**
	 * remove the mesh data from the GPU
	 */
	override public function dispose( data:IMeshData ):Void
	{
		this.unbind( data, null );

		// ---------- //

		if ( this.indexBuffer != null )
		{
			this.indexBuffer.dispose();
			this.indexBuffer = null;
		}

		if ( this.vertexBuffer != null )
		{
			this.vertexBuffer.dispose();
			this.vertexBuffer = null;
		}
	}

	// ************************************************************************ //
	// Bind
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as currently active on the GPU (shader calls will use this allocated mesh then)
	 */
	override public function bind( data:IMeshData, shader:IShader ):Void
	{
		this.setVertexAttributes( shader, data.signature );
	}

	/**
	 *
	 * @param	mesh
	 */
	private function setVertexAttributes( shader:IShader, signature:MeshSignature ):Void
	{
		var pos:Int 	= 0;
		var offset:Int 	= 0;

		for ( t in 0...signature.numRegisters )
		{
			var register:RegisterType = signature.getRegisterTypeByIndex( t );
			var location:Int = this.getVertexAttributeLocation( shader, register );

			if ( location != -1 )
			{
				this.context.setVertexBufferAt( pos, this.vertexBuffer, offset, this.getVertexBufferFormat( register.format ) );
				pos++;
			}

			offset += register.size;
		}
	}

	/**
	 *
	 * @param	name
	 * @return
	 */
	private function getVertexAttributeLocation( shader:IShader, register:RegisterType ):Int
	{
		var location:Int = 0;

		for( j in 0...shader.data.signature.numRegisters )
		{
			var sregister:RegisterType = shader.data.signature.getRegisterTypeByIndex( j );

			if( sregister.ID == register.ID )
				return location;

			location++;
		}

		return -1;
	}

	/**
	 *
	 * @param	format
	 */
	private function getVertexBufferFormat( format:RegisterFormat ):Context3DVertexBufferFormat
	{
		switch( format )
		{
			case RegisterFormat.TFLOAT_1: 	return Context3DVertexBufferFormat.FLOAT_1;
			case RegisterFormat.TFLOAT_2: 	return Context3DVertexBufferFormat.FLOAT_2;
			case RegisterFormat.TFLOAT_3: 	return Context3DVertexBufferFormat.FLOAT_3;
			case RegisterFormat.TFLOAT_4: 	return Context3DVertexBufferFormat.FLOAT_4;
			case RegisterFormat.TINT: 		return Context3DVertexBufferFormat.BYTES_4; //?

			default:
				throw "not a vertexbuffer format";
		}

		return Context3DVertexBufferFormat.BYTES_4;
	}

	// ************************************************************************ //
	// Unbind
	// ************************************************************************ //

	/**
	 * sets the mesh buffer as inactive on the GPU (no mesh will be active for shader calls then)
	 */
	override public function unbind( data:IMeshData, shader:IShader ):Void
	{
		for ( i in 0...data.signature.numRegisters )
			this.context.setVertexBufferAt( i, null );
	}
}