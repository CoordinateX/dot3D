package;

import haxe.Int64;
import java.lang.Long;
import java.NativeArray;

import org.lwjgl.glfw.GLFW;
import org.lwjgl.glfw.GLFWvidmode;
import org.lwjgl.glfw.GLFWErrorCallback;
import org.lwjgl.glfw.GLFWKeyCallback;
import org.lwjgl.glfw.Callbacks;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL15;
import org.lwjgl.opengl.GL20;
import org.lwjgl.opengl.GL30;
import org.lwjgl.opengl.GLContext;
import org.lwjgl.BufferUtils;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

/**
 * ...
 * @author RK
 */
class JavaMain
{

	private static var instance:JavaMain;

	// ---------------- //

	private var errorCallback:GLFWErrorCallback;
	private var keyInputCallback:MyKeyInputCallback;

	// ---------------- //

	private var ptr_window:Long;

	private var ptr_bufferA:Int;
	private var ptr_bufferB:Int;
	private var ptr_shader:Int;

	// ************************************************************************ //
	// Constructor
	// ************************************************************************ //

	public static function main()
    {
		JavaMain.instance = new JavaMain();
    }

	public function new()
	{
		trace("main");

        try
		{
			this.initializeWindow();
			this.initializeShader();
			this.loop();
        }
		catch( e:Dynamic )
		{
			throw e; // so we catch java exceptions, yet throw it with a trusty callstack
        }

        Sys.exit(0);
	}

	// ************************************************************************ //
	// Methods
	// ************************************************************************ //

	public function test():String
	{
		return "this is awesome?";
	}

	/**
	 *
	 */
	private function initializeWindow():Void
	{
		if( GLFW.glfwInit() != GL11.GL_TRUE )
			throw "Unable to initialize GLFW";

		GLFW.glfwSetErrorCallback( this.errorCallback = new MyErrorCallback() );

		// ---------- //
		// init window:

		GLFW.glfwDefaultWindowHints();
		GLFW.glfwWindowHint( GLFW.GLFW_CONTEXT_VERSION_MAJOR, 3);
		GLFW.glfwWindowHint( GLFW.GLFW_CONTEXT_VERSION_MINOR, 2);
		GLFW.glfwWindowHint( GLFW.GLFW_OPENGL_PROFILE, GLFW.GLFW_OPENGL_CORE_PROFILE);
		GLFW.glfwWindowHint( GLFW.GLFW_OPENGL_FORWARD_COMPAT, GL11.GL_TRUE );

		var WIDTH:Int  = 960;
		var HEIGHT:Int = 540;

		this.ptr_window = GLFW.glfwCreateWindow( 960, 540, "dot3D", 0, 0 );

		// ---------- //
		// keyInput:

		GLFW.glfwSetKeyCallback( this.ptr_window, this.keyInputCallback = new MyKeyInputCallback() );

		// ---------- //
		// setup window:

		var vidmode:ByteBuffer = GLFW.glfwGetVideoMode( GLFW.glfwGetPrimaryMonitor() );

		var w:Int = Std.int( ( GLFWvidmode.width(vidmode)  - WIDTH )  * 0.5 );
		var h:Int = Std.int( ( GLFWvidmode.height(vidmode) - HEIGHT ) * 0.5 );

		GLFW.glfwSetWindowPos( this.ptr_window, w, h );

		GLFW.glfwMakeContextCurrent( this.ptr_window );
		GLFW.glfwSwapInterval(1);
	}

	/**
	 *
	 */
	private function initializeShader():Void
	{
		GLContext.createFromCurrent();

		// --------- //

		var vertex_program:String = "";
			vertex_program += "#version 330                                \n";
			vertex_program += "in vec2 position;                           \n";
			vertex_program += "void main(){                                \n";
			vertex_program += "    gl_Position= vec4(position,0,1);        \n";
			vertex_program += "}                                           \n";

		var fragment_program:String = "";
			fragment_program += "#version 330                               \n";
            fragment_program += "out vec3 out_color;                        \n";
            fragment_program += "void main(){                               \n";
            fragment_program += "    out_color= vec3(0.7,0.1,0.2);      	\n";
            fragment_program += "}                                          \n";

		var shader:Int = this.createShaderProgram(vertex_program, fragment_program );

		// --------- //

		var vaoID:Int = GL30.glGenVertexArrays();
        GL30.glBindVertexArray( vaoID );

		var vpositions:NativeArray<Single> = new NativeArray<Single>( 6 );
			vpositions[0]  =  0.0;
			vpositions[1]  =  0.8;
			vpositions[2]  = -0.8;
			vpositions[3]  = -0.8;
			vpositions[4]  =  0.8;
			vpositions[5]  = -0.8;

		//for( j in 0...6 )
		//	vpositions[j] *= 2;

		var vpBuffer:FloatBuffer = BufferUtils.createFloatBuffer( vpositions.length );
			vpBuffer.put( vpositions, 0, vpositions.length );
			vpBuffer.flip();

		// --------- //

		var vboID:Int = GL15.glGenBuffers();

		GL15.glBindBuffer( GL15.GL_ARRAY_BUFFER, vboID );
        GL15.glBufferData( GL15.GL_ARRAY_BUFFER, vpBuffer, GL15.GL_STATIC_DRAW );

		GL20.glVertexAttribPointer( 0, 2, GL11.GL_FLOAT, false, 0, 0 );
        GL30.glBindVertexArray(0);

		this.ptr_bufferA = vaoID;
		this.ptr_bufferB = vboID;
		this.ptr_shader = shader;
	}

	/**
	 *
	 * @param	vertex_program
	 * @param	fragment_program
	 */
	private function createShaderProgram( vertex_program:String, fragment_program:String ):Int
	{
		var vshader:Int = GL20.glCreateShader( GL20.GL_VERTEX_SHADER );

		GL20.glShaderSource( vshader, vertex_program );
		GL20.glCompileShader( vshader );

		var vstatus:Int = GL20.glGetShaderi( vshader, GL20.GL_COMPILE_STATUS );

		if( vstatus == GL11.GL_FALSE )
			throw "error compiling vertex shader: " + GL20.glGetShaderInfoLog(vshader);

		// -------- //

		var fshader:Int = GL20.glCreateShader( GL20.GL_FRAGMENT_SHADER );

		GL20.glShaderSource( fshader, fragment_program );
		GL20.glCompileShader( fshader );

		var fstatus:Int = GL20.glGetShaderi( fshader, GL20.GL_COMPILE_STATUS );

		if( fstatus == GL11.GL_FALSE )
			throw "error compiling fragment shader: " + GL20.glGetShaderInfoLog(fshader);

		// -------- //

		var program:Int = GL20.glCreateProgram();

		GL20.glAttachShader( program, vshader );
		GL20.glAttachShader( program, fshader );

		GL20.glBindAttribLocation( program, 0, "position" );
		GL20.glLinkProgram( program );

		var pstatus:Int = GL20.glGetShaderi( program, GL20.GL_LINK_STATUS );

		if( pstatus == GL11.GL_FALSE )
			throw "error linking shader program: " + GL20.glGetProgramInfoLog( program );

		GL20.glDetachShader( program, vshader );
		GL20.glDetachShader( program, fshader );

		return program;
	}

	/**
	 *
	 */
	private function loop():Void
	{
		GL11.glViewport(0, 0, 960, 540);
        GL11.glClearColor( 0.1, 0.1, 0.1, 0.0 );

        while( GLFW.glfwWindowShouldClose( this.ptr_window ) == GL11.GL_FALSE )
		{
            GL11.glClear( GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT ); 	// clear the framebuffer

			// ----------- //

			GL20.glUseProgram( this.ptr_shader );

			GL30.glBindVertexArray( this.ptr_bufferA );
			GL20.glEnableVertexAttribArray( 0 );

			GL11.glDrawArrays( GL11.GL_LINES, 0, 6 );

			GL20.glDisableVertexAttribArray(0);
			GL30.glBindVertexArray(0);
			GL20.glUseProgram(0);

			// ----------- //

            GLFW.glfwPollEvents();													// e.g. keyinput for close
			GLFW.glfwSwapBuffers( this.ptr_window ); 								// swap the color buffers
        }
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
		trace("ERROR:", code, Callbacks.errorCallbackDescriptionString( ptr_description ) );
	}
}

/**
 *
 */
class MyKeyInputCallback extends GLFWKeyCallback
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
	override public function invoke( window:Int64, key:Int, scancode:Int, action:Int, mods:Int )
	{
		if ( key == GLFW.GLFW_KEY_ESCAPE && action == GLFW.GLFW_RELEASE )
		{
			GLFW.glfwSetWindowShouldClose( window, GL11.GL_TRUE ); // We will detect this in our rendering loop
		}
	}
}