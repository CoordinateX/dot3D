package haxe.at.dotpoint.dot3d.material;

import haxe.at.dotpoint.display.renderable.bitmap.BitmapData;
import haxe.at.dotpoint.display.renderable.geometry.material.AMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.IMaterial;
import haxe.at.dotpoint.display.renderable.geometry.material.MaterialSignature;
import haxe.at.dotpoint.display.rendering.register.RegisterHelper;
import haxe.at.dotpoint.display.rendering.register.RegisterType;
import haxe.at.dotpoint.dot3d.rendering.renderable.Texture;
import haxe.at.dotpoint.math.vector.Vector3;

/**
 * ...
 * @author RK
 */
class DiffuseTextureMaterial extends AMaterial implements IMaterial
{
	
	/**
	 * 
	 */
	public var diffuseTexture:Texture;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new( diffuse:Texture ) 
	{
		super();
		
		this.signature = new MaterialSignature( "DiffuseTexture", 1 );
		this.signature.addRegisterType( RegisterHelper.M_TEXTURE_DIFFUSE );
		
		this.diffuseTexture = diffuse;
	}
	
	// ************************************************************************ //
	// Methods
	// ************************************************************************ //	

	/**
	 * 
	 * @param	type
	 * @return
	 */
	inline public function getRegisterData<T:Dynamic>( type:RegisterType ):T
	{
		if( type.ID == RegisterHelper.M_TEXTURE_DIFFUSE.ID )
			return cast this.diffuseTexture;
		
		return null;
	}
	
		/**
	 * 
	 * @param	type
	 * @param	data
	 */
	public function setRegisterData( type:RegisterType, data:Dynamic ):Void
	{
		return;
	}
}