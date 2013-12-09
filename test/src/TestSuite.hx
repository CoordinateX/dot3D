import massive.munit.TestSuite;

import dot3d.MeshSignaturTest;
import ExampleTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(dot3d.MeshSignaturTest);
		add(ExampleTest);
	}
}
