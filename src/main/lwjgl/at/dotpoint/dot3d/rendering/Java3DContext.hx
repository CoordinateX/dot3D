package lwjgl.at.dotpoint.dot3d.rendering;

import haxe.at.dotpoint.core.dispatcher.event.EventDispatcher;
import haxe.at.dotpoint.core.dispatcher.event.generic.StatusEvent;
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
class Java3DContext extends EventDispatcher implements IRenderContext
{

	/**
	 *
	 */
	private var viewport:RenderViewport;

	/**
	 *
	 */
	private var settings:RenderSettings;

	// ----------- //

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

		this.ptr_window = -1;

		this.viewport = new RenderViewport();
		this.settings = new RenderSettings();
	}

	// ************************************************************************ //
	// getter/setter
	// ************************************************************************ //

	/**
	 *
	 * @return
	 */
	public function getViewport():RenderViewport
	{
		return this.viewport;
	}

	/**
	 *
	 * @return
	 */
	public function getSettings():RenderSettings
	{
		return this.settings;
	}

	/**
	 *
	 * @return
	 */
	public function isInitialized():Bool
	{
		return this.ptr_window != -1 && this.ptr_window != null;
	}

	// ************************************************************************ //
	// Initialize
	// ************************************************************************ //

	/**
	 *
	 */
	public function initialize( onComplete:StatusEvent->Void ):Void
	{
		if( onComplete != null )
			this.addListener( StatusEvent.COMPLETE, cast onComplete );

		// ------------ //

		GLFW.glfwSetErrorCallback( this.errorCallback = new MyErrorCallback() );

		if( GLFW.glfwInit() != GL11.GL_TRUE )
			throw "Unable to initialize Java3DContext: GLFW.glfwInit() failed";

		if( this.viewport.width == 0 || this.viewport.height == 0 )
			throw "Unable to initialize Java3DContext: Viewport width/height is invalid (aspect-ratio:0)";

		// ---------- //
		// init window:

		GLFW.glfwDefaultWindowHints();
		GLFW.glfwWindowHint( GLFW.GLFW_CONTEXT_VERSION_MAJOR, 3);
		GLFW.glfwWindowHint( GLFW.GLFW_CONTEXT_VERSION_MINOR, 2);
		GLFW.glfwWindowHint( GLFW.GLFW_OPENGL_PROFILE, GLFW.GLFW_OPENGL_CORE_PROFILE);
		GLFW.glfwWindowHint( GLFW.GLFW_OPENGL_FORWARD_COMPAT, GL11.GL_TRUE );

		this.ptr_window = GLFW.glfwCreateWindow( this.viewport.width, this.viewport.height, "dot3D", 0, 0 );

		// ---------- //
		// setup window:

		var vidmode:ByteBuffer = GLFW.glfwGetVideoMode( GLFW.glfwGetPrimaryMonitor() );

		var w:Int = Std.int( ( GLFWvidmode.width(vidmode)  - this.viewport.width )  * 0.5 );
		var h:Int = Std.int( ( GLFWvidmode.height(vidmode) - this.viewport.height ) * 0.5 );

		GLFW.glfwSetWindowPos( this.ptr_window, w, h );

		// ---------- //

		GLFW.glfwMakeContextCurrent( this.ptr_window );
		GLFW.glfwSwapInterval(1);

		GLContext.createFromCurrent();

		// ----------- //

		var bgcolor:Vector3 = this.settings.colorBackground;

		GL11.glViewport( 0, 0, this.viewport.width, this.viewport.height );
        GL11.glClearColor( bgcolor.x, bgcolor.y, bgcolor.z, 0.0 );

		// ---------- //

		this.dispatch( new StatusEvent( StatusEvent.COMPLETE ) );
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