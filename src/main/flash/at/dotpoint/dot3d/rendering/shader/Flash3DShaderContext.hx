package flash.at.dotpoint.dot3d.rendering.shader;

import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DTriangleFace;

/**
 * specifies Context3D render settings for a material. You can create some interessting 
 * effects disabeling depthTests, changing blendModes or simply changing how triangles
 * should be culled. take a look into the corresbonding flash docs
 *
 * @author Gerald Hattensauer
 */
class Flash3DShaderContext
{

	/**
	 * which side of the triangle should be rendered?, both? none?
	 */
	public var culling:Context3DTriangleFace;
	
	/**
	 * BlendFactors
	 */
	public var blendSRC:Context3DBlendFactor;
	public var blendDST:Context3DBlendFactor;
	
	/**
	 * DepthTest
	 */
	public var depthTestMode:Context3DCompareMode;	
	public var depthTest:Bool;
	
	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //	
	
	public function new() 
	{
		this.culling  = Context3DTriangleFace.FRONT;
		
		this.blendSRC = Context3DBlendFactor.ONE;
		this.blendDST = Context3DBlendFactor.ZERO;		
		
		this.depthTestMode 	= Context3DCompareMode.LESS;
		this.depthTest 		= true;		
	}
	
	/**
	 * 
	 * @return
	 */
	public function clone():Flash3DShaderContext
	{
		var settings:Flash3DShaderContext = new Flash3DShaderContext();		
			settings.blendSRC 		= this.blendSRC;
			settings.blendDST 		= this.blendDST;			
			settings.depthTest 		= this.depthTest;
			settings.depthTestMode 	= this.depthTestMode;			
			settings.culling 		= this.culling;
		
		return settings;
	}
}