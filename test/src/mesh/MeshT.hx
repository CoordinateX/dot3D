package mesh;

import at.dotpoint.dot3d.model.mesh.MeshData;
import at.dotpoint.dot3d.model.mesh.Vertex;
import at.dotpoint.dot3d.model.register.error.RegisterError;
import at.dotpoint.dot3d.model.register.Register;
import massive.munit.Assert;

/**
 * ...
 * @author RK
 */
class MeshT
{

	private var mesh:MeshData;
	
	inline static function v1( index:Int = 0 ):Vertex
	{ 
		var v:Vertex = new Vertex( index );
			v.setData( Register.VERTEX_POSITION, 0, [0.1, 0.2, 0.3] );
			
		return v;
	}
	
	inline static function v2( index:Int = 1 ):Vertex
	{ 
		var v:Vertex = new Vertex( index );
			v.setData( Register.VERTEX_POSITION, 0, [1.1, 1.2, 1.3] );
			
		return v;
	}
	
	inline static function v3( index:Int = 2 ):Vertex
	{ 
		var v:Vertex = new Vertex( index );
			v.setData( Register.VERTEX_POSITION, 0, [2.1, 2.2, 2.3] );
			
		return v;
	}
	
	// ************************************************************************ //
	// ************************************************************************ //
	
	public function new(){		
	}
	
	private function setMesh( size:Int ):Void
	{
		throw "override";
	}
	
	// ************************************************************************ //
	// ************************************************************************ //
	
	/**
	 * 
	 */
	@Test
	public function testVertex():Void
	{
		this.setMesh( 2 );
		
		this.setVertex( v1(), 0 );
		this.setVertex( v2(), 1 );
		
		try
		{
			this.setVertex( v3(), 2 ); 
		}
		catch( error:RegisterError )
		{
			Assert.areEqual( RegisterError.ID_BOUNDS, error.code );
		}			
	}
	
	/**
	 * 
	 */
	@Test
	public function testVertex_viaIndex():Void
	{
		this.setMesh( 2 );
		
		var v1:Vertex = v1(1); 		// swapped index - so v1 is second vertex
		var v2:Vertex = v2(0);
		
		this.mesh.setVertex( v1 );	
		this.mesh.setVertex( v2 );	
		
		this.checkVertex( v2, this.mesh.getVertex( 0 ) );
		this.checkVertex( v1, this.mesh.getVertex( 1 ) );
		
		Assert.areNotEqual( v1.index, this.mesh.getVertex( 0 ) );
		Assert.areNotEqual( v2.index, this.mesh.getVertex( 1 ) );
	}
	
	/**
	 * 
	 */
	private function setVertex( vertex:Vertex, checkIndex:Int ):Void
	{
		this.mesh.setVertex( vertex );	
		
		var result:Vertex = this.mesh.getVertex( checkIndex );
		this.checkVertex( vertex, result );		
	}
	
	/**
	 * 
	 * @param	vertex
	 * @param	result
	 */
	private function checkVertex( vertex:Vertex, result:Vertex ):Void
	{
		Assert.isNotNull( vertex );
		Assert.isNotNull( result );
		
		Assert.areNotSame( vertex, result );
		
		// ---------- //
		// index:
		
		Assert.areEqual( vertex.index, result.index );		
		
		// ---------- //
		// pos:
		
		var result_pos:Array<Float> = result.getData( Register.VERTEX_POSITION, 0 );
		var origin_pos:Array<Float> = vertex.getData( Register.VERTEX_POSITION, 0 );
		
		Assert.isNotNull( result_pos );
		Assert.isNotNull( origin_pos );
		
		Assert.areNotSame( origin_pos, result_pos );
		
		Assert.areEqual( result_pos[0], origin_pos[0] );
		Assert.areEqual( result_pos[1], origin_pos[1] );
		Assert.areEqual( result_pos[2], origin_pos[2] );
	}
}