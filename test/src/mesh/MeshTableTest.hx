package mesh;

import at.dotpoint.dot3d.model.mesh.MeshData;
import at.dotpoint.dot3d.model.register.container.RegisterTable;

/**
 * ...
 * @author RK
 */
class MeshTableTest extends MeshT
{

	public function new()
	{
		super();
	}
	
	override private function setMesh( size:Int ):Void
	{
		this.mesh = new MeshData( new RegisterTable( size ) );
	}
}