package mesh;

import at.dotpoint.dot3d.model.mesh.MeshData;
import at.dotpoint.dot3d.model.register.container.RegisterList;

/**
 * ...
 * @author RK
 */
class MeshListTest extends MeshT
{

	public function new()
	{
		super();
	}
	
	override private function setMesh( size:Int ):Void
	{
		this.mesh = new MeshData( new RegisterList( size ) );
	}
}