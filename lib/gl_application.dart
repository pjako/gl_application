library gl_application;
import 'dart:html';
import 'dart:math' as Math;
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:game_loop/game_loop.dart';
import 'package:spectre/spectre.dart';






abstract class GLApplication {
  /// The red value to clear the color buffer to.
  final double redClearColor = 70.0 / 255.0;
  /// The green value to clear the color buffer to.
  final double greenClearColor = 70.0 / 255.0;
  /// The blue value to clear the color buffer to.
  final double blueClearColor = 70.0 / 255.0;
  /// The alpha value to clear the color buffer to.
  final double alphaClearColor = 1.0;


  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The [GameLoop] used by this application
  GameLoop _gameLoop;
  GameLoop get gameLoop => _gameLoop;

  /// The [GraphicsDevice] used by the application.
  ///
  /// All [GraphicsResource]s are created through the [GraphicsDevice].
  GraphicsDevice _graphicsDevice;
  GraphicsDevice get graphicsDevice => _graphicsDevice;
  /// The [GraphicsContext] used by the application.
  ///
  /// The [GraphicsContext] is used to render the scene. All the rendering
  /// commands pass through the context.
  GraphicsContext _graphicsContext;
  GraphicsContext get graphicsContext => _graphicsContext;

  //---------------------------------------------------------------------
  // Debug drawing member variables
  //---------------------------------------------------------------------

  /// Retained mode debug draw manager.
  ///
  /// Used to draw debugging information to the screen. In this sample the
  /// skeleton of the mesh is drawn by the [DebugDrawManager].
  DebugDrawManager _debugDrawManager;
  DebugDrawManager get debugDrawManager => _debugDrawManager;
  /// Whether debugging information should be drawn.
  ///
  /// If the debugging information is turned on in this sample the
  /// mesh's skeleton will be displayed.
  bool _drawDebugInformation = false;

  BlendState _debugBlend;

  //---------------------------------------------------------------------
  // Camera member variables
  //---------------------------------------------------------------------

  /// The [Camera] being used to view the scene.
  Camera _camera;
  Camera get camera => _camera;
  /// The [MouseKeyboardCameraController] which allows the movement of the [Camera].
  ///
  /// A [MouseKeyboardCameraController] provides a way to move the camera in the
  /// same way that a free-look FPS operates.
  //MouseKeyboardCameraController _cameraController;

  /// [Float32Array] storage for the Model-View matrix.
  Float32Array _modelViewMatrixArray;
  Float32Array get modelViewMatrixArray => _modelViewMatrixArray;

  /// [Float32Array] storage for the normal matrix.
  Float32Array _normalMatrixArray;
  Float32Array get normalMatrixArray => _normalMatrixArray;

  /// The [Viewport] to draw to.
  Viewport _viewport;





  //---------------------------------------------------------------------
  // Construction
  //---------------------------------------------------------------------

  /// Creates an instance of the [Application] class.
  ///
  /// The application is hosted within the [CanvasElement] specified in [canvas].
  GLApplication(CanvasElement canvas) {

    _gameLoop = new GameLoop(canvas);
    _gameLoop.onUpdate = _onUpdate;
    _gameLoop.onResize = _onResize;
    _gameLoop.onRender = _onRender;


    // Resize the canvas using the offsetWidth/offsetHeight.
    //
    // The canvas width/height is not being explictly specified in the markup,
    // but the canvas needs to take up the entire contents of the window. The
    // stylesheet accomplishes this but the underlying canvas will default to
    // 300x150 which will produce a really low resolution image.
    int width = canvas.offsetWidth;
    int height = canvas.offsetHeight;

    canvas.width = width;
    canvas.height = height;

    // Create the GraphicsDevice and attaches the AssetManager
    _createGraphicsDevice(canvas);

    // Create the DebugDrawManager for the GraphicsDevice

    _debugBlend = new BlendState.opaque("Debug.blend", _graphicsDevice);

    // Create the viewport
    _viewport = new Viewport('Viewport', _graphicsDevice);

    // Create the Camera and the CameraController
    _createCamera();


    // Resize the viewport
    _viewport.width = width;
    _viewport.height = height;

    // Change the aspect ratio of the camera
    _camera.aspectRatio = _viewport.aspectRation;

    // Start loading the resources
    //_loadResources();


  }

  /// Creates the [GraphicsDevice] and attaches the [AssetManager].
  void _createGraphicsDevice(CanvasElement canvas) {
    // Create the GraphicsDevice using the CanvasElement
    _graphicsDevice = new GraphicsDevice(canvas);

    // Get the GraphicsContext from the GraphicsDevice
    _graphicsContext = _graphicsDevice.context;
  }


  /// Create the [Camera] and the [CameraController] to position it.
  void _createCamera() {
    // Create the Camera
    _camera = new Camera();
    _camera.position = new vec3.raw(1.0, 1.0, 1.0);
    _camera.focusPosition = new vec3.raw(0.0, 0.0, 0.0);



    // Create the mat4 holding the Model-View-Projection matrix
    //_modelViewProjectionMatrix =

    // Create the Float32Arrays that store the constant values for the matrices
    _modelViewMatrixArray = new Float32Array(16);
    //_modelViewProjectionMatrixArray
    _normalMatrixArray = new Float32Array(16);
  }



  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether debugging information should be drawn.
  ///
  /// If the debugging information is turned on in this sample the
  /// mesh's skeleton will be displayed.
  bool get drawDebugInformation => _drawDebugInformation;
  set drawDebugInformation(bool value) {
    if(_debugDrawManager == null && value == true) {
      _debugDrawManager = new DebugDrawManager(_graphicsDevice);
    }
    _drawDebugInformation = value;
  }

  /// Resizes the application viewport.
  ///
  /// Changes the [Viewport]'s dimensions to the values contained in [width]
  /// and [height]. Additionally the [Camera]'s aspect ratio needs to be adjusted
  /// accordingly.
  ///
  /// This needs to occur whenever the underlying [CanvasElement] is resized,
  /// otherwise the rendered scene will be incorrect.
  void _onResize(GameLoop gameLoop) {
    int width = gameLoop.width,
        height = gameLoop.height;
    // Resize the viewport
    _viewport.width = width;
    _viewport.height = height;

    // Change the aspect ratio of the camera
    _camera.aspectRatio = _viewport.aspectRation;
    onResize(width, height);

  }

  void _onUpdate(GameLoop gameLoop) {
    double dt = gameLoop.dt;
    // Update DebugManager
    if(_drawDebugInformation == true) {
      _debugDrawManager.update(dt);
    }
    onUpdate(dt);



    // Copy the View matrix from the camera into the Float32Array.
    _camera.copyViewMatrixIntoArray(_modelViewMatrixArray);

    // Copy the Normal matrix from the camera into the Float32Array.
    _camera.copyNormalMatrixIntoArray(_normalMatrixArray);


  }
  void _onRender(GameLoop gameLoop) {
    // Clear the color and depth buffer
    _graphicsContext.clearColorBuffer(
      redClearColor,
      greenClearColor,
      blueClearColor,
      alphaClearColor
    );
    _graphicsContext.clearDepthBuffer(1.0);

    // Reset the graphics context
    _graphicsContext.reset();
    _graphicsContext.setViewport(_viewport);
    onRender();

    if (_drawDebugInformation == true) {

      _debugDrawManager.prepareForRender();
      _debugDrawManager.render(_camera);
    }
  }

  //---------------------------------------------------------------------
  // Public methods
  //---------------------------------------------------------------------

  /// Resizes the application viewport.
  ///
  /// Changes the [Viewport]'s dimensions to the values contained in [width]
  /// and [height]. Additionally the [Camera]'s aspect ratio needs to be adjusted
  /// accordingly.
  ///
  /// This needs to occur whenever the underlying [CanvasElement] is resized,
  /// otherwise the rendered scene will be incorrect.
  void onResize(int width, int height);


  /// Updates the application.
  ///
  /// Uses the current change in time, [dt].
  void onUpdate(double dt);

  /// Renders the application
  void onRender();

  void start() {
    _gameLoop.start();
  }
  void stop() {
    _gameLoop.stop();
  }
}

