package haxe.at.dotpoint.dot3d.renderable.material;

import haxe.at.dotpoint.display.renderable.material.AMaterial;
import haxe.at.dotpoint.display.renderable.material.data.AMaterialData;
import haxe.at.dotpoint.display.renderable.material.data.MaterialSignature;
import haxe.at.dotpoint.display.renderable.register.RegisterHelper;
import haxe.at.dotpoint.display.renderable.register.type.RegisterType;
import haxe.at.dotpoint.math.vector.Vector3;

/**
 *
 */
class DiffuseColorMaterial extends AMaterial
{
	//
	public static var NAME(default, null):String = "diffusecolor";

	//
	public function new()
	{
		super( new DiffuseColorMaterialData( DiffuseColorMaterial.NAME ) );
	}

}

/**
 * ...
 * @author RK
 */
class DiffuseColorMaterialData extends AMaterialData
{

	/**
	 *
	 */
	public var diffuseColor:Vector3;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new( name:String, ?color:Vector3 )
	{
		super( name );

		if( color == null )
			color = new Vector3( Math.random(), Math.random(), Math.random() );

		this.diffuseColor = color;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 * returns a current list of RegisterTypes used, number of (unique) vertices and triangles
	 */
	override private function calculateSignature():MaterialSignature
	{
		var signature:MaterialSignature = new MaterialSignature( 1, 0 );
			signature.addRegisterType( RegisterHelper.M_COLOR );

		return signature;
	}

	// ************************************************************************ //
	// RegisterData
	// ************************************************************************ //

	/**
	 *
	 */
	override public function getRegisterData( type:RegisterType ):Array<Float>
	{
		if( type.ID == RegisterHelper.M_COLOR.ID )
			return this.diffuseColor.toArray( true );

		return null;
	}
}