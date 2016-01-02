package lwjgl.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
import haxe.at.dotpoint.display.rendering.context.ARenderContext;
import haxe.at.dotpoint.display.rendering.context.IRenderContext;
import haxe.at.dotpoint.display.rendering.context.RenderSettings;
import haxe.at.dotpoint.display.rendering.context.RenderViewport;
import haxe.at.dotpoint.logger.Log;
import haxe.at.dotpoint.math.vector.Vector3;
import haxe.Int64;
import java.lang.Long;
import java.nio.ByteBuffer;
import org.lwjgl.glfw.GLFW;
import org.lwjgl.glfw.GLFWvidmode;
import org.lwjgl.glfw.GLFWErrorCallback;
import org.lwjgl.glfw.Callbacks;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GLContext;


/**
 * ...
 * @author RK
 */
class RenderContext extends ARenderContext<RenderViewport,RenderSettings> implements IRenderContext
{

	/**
	 *
	 */
	private var errorCallback:GLFWErrorCallback;

	/**
	 * pointer to the active window (only one supported)
	 */
	public var ptr_window(default,null):Long;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public function new()
	{
		super();

		this.viewport = new RenderViewport();
		this.settings = new RenderSettings();

		this.ptr_window = -1;
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	/**
	 *
	 */
	override public function initialize( onComplete:StatusEvent->Void ):Void
	{
		super.initialize( onComplete );

		// ------------ //

		GLFW.glfwSetErrorCallback( this.errorCallback = new MyErrorCallback() );

		if( GLFW.glfwInit() != GL11.GL_TRUE )
			throw "Unable to initialize RenderContext: GLFW.glfwInit() failed";

		if( this.viewport.width == 0 || this.viewport.height == 0 )
			throw "Unable to initialize RenderContext: Viewport width/height is invalid (aspect-ratio:0)";

		// ---------- //

		this.createWindow();
		this.createGLContext();

		// ---------- //

		this.onInitComplete();
	}

	/**
	 *
	 */
	private function createWindow( ?title:String = "dot3D" ):Void
	{
		GLFW.glfwDefaultWindowHints();
		GLFW.glfwWindowHint( GLFW.GLFW_CONTEXT_VERSION_MAJOR, 3);
		GLFW.glfwWindowHint( GLFW.GLFW_CONTEXT_VERSION_MINOR, 2);
		GLFW.glfwWindowHint( GLFW.GLFW_OPENGL_PROFILE, GLFW.GLFW_OPENGL_CORE_PROFILE);
		GLFW.glfwWindowHint( GLFW.GLFW_OPENGL_FORWARD_COMPAT, GL11.GL_TRUE );

		this.ptr_window = GLFW.glfwCreateWindow( this.viewport.width, this.viewport.height, title, 0, 0 );

		// --------------- //

		var vidmode:ByteBuffer = GLFW.glfwGetVideoMode( GLFW.glfwGetPrimaryMonitor() );

		var w:Int = Std.int( ( GLFWvidmode.width(vidmode)  - this.viewport.width )  * 0.5 );
		var h:Int = Std.int( ( GLFWvidmode.height(vidmode) - this.viewport.height ) * 0.5 );

		GLFW.glfwSetWindowPos( this.ptr_window, w, h );
	}

	/**
	 *
	 */
	private function createGLContext():Void
	{
		GLFW.glfwMakeContextCurrent( this.ptr_window );
		GLFW.glfwSwapInterval(1);

		GLContext.createFromCurrent();

		// ----------- //

		GL11.glEnable(GL11.GL_CULL_FACE);
		GL11.glCullFace(GL11.GL_BACK);
		GL11.glFrontFace(GL11.GL_CCW);
		GL11.glEnable(GL11.GL_DEPTH_TEST);
		GL11.glDepthMask(true);
		GL11.glDepthFunc(GL11.GL_LEQUAL);

		// ----------- //

		var bgcolor:Vector3 = this.settings.colorBackground;

		GL11.glViewport( 0, 0, this.viewport.width, this.viewport.height );
        GL11.glClearColor( bgcolor.x, bgcolor.y, bgcolor.z, 0.0 );
	}
}

/**
 *
 */
class MyErrorCallback extends GLFWErrorCallback
{
	public function new()
	{
		super();
	}

	/**
	 *
	 * @param	code
	 * @param	ptr_description
	 */
	@:overload
	//
	override public function invoke( code:Int, ptr_description:Int64 ):Void
	{
		Log.error( code + ": " + Callbacks.errorCallbackDescriptionString( ptr_description ) );
	}
}