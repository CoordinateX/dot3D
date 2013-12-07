package at.dotpoint.dot3d.model.material;

import at.dotpoint.ICloneable;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DTriangleFace;

/**
 * ...
 * @author Gerald Hattensauer
 */
class ContextSettings
{

	public var blendSRC:Context3DBlendFactor;
	public var blendDST:Context3DBlendFactor;
	
	public var depthTest:Bool;
	public var depthTestMode:Context3DCompareMode;
	
	public var culling:Context3DTriangleFace;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		this.blendSRC = Context3DBlendFactor.ONE;
		this.blendDST = Context3DBlendFactor.ZERO;
		
		this.depthTest 		= true;
		this.depthTestMode 	= Context3DCompareMode.LESS;
		
		this.culling = Context3DTriangleFace.BACK;
	}
	
	/**
	 * 
	 * @return
	 */
	public function clone():ContextSettings
	{
		var settings:ContextSettings = new ContextSettings();		
			settings.blendSRC 		= this.blendSRC;
			settings.blendDST 		= this.blendDST;			
			settings.depthTest 		= this.depthTest;
			settings.depthTestMode 	= this.depthTestMode;			
			settings.culling 		= this.culling;
		
		return settings;
	}
}