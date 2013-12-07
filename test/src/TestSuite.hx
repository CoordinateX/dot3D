import massive.munit.TestSuite;

import mesh.MeshListTest;
import mesh.MeshTableTest;
import register.RegisterListTest;
import register.RegisterTableTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(mesh.MeshListTest);
		add(mesh.MeshTableTest);
		add(register.RegisterListTest);
		add(register.RegisterTableTest);
	}
}
