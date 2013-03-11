import 'dart:html';
import 'dart:math' as Math;
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:game_loop/game_loop.dart';
import 'package:spectre/spectre.dart';
import 'package:spectre/spectre_renderer.dart';
import 'package:asset_pack/asset_pack.dart';
import "../lib/gl_application.dart";

part 'poly_constructor.dart';
//import 'package:spectre/spectre.dart';
//import 'package:poly_helper/poly_constructor.dart';

var vs =
"""
#ifdef GL_ES
precision highp float;
#endif
//---------------------------------------------------------------------
// Vertex attributes
//---------------------------------------------------------------------

/// The vertex position.
attribute vec3 vPosition;
/// The texture coordinate.
attribute vec2 vTexCoord0;
/// The vertex normal.
//attribute vec3 vNormal;

//---------------------------------------------------------------------
// Uniform variables
//---------------------------------------------------------------------

/// The Model-View matrix.
uniform mat4 uModelViewMatrix;
/// The Model-View-Projection matrix.
uniform mat4 uModelViewProjectionMatrix;
/// The normal matrix
uniform mat4 uNormalMatrix;

//---------------------------------------------------------------------
// Varying variables
//
// Allows communication between vertex and fragment stages
//---------------------------------------------------------------------

/// The texture coordinate of the vertex.
varying vec2 texCoord;

void main() {
  vec4 vPosition4 = vec4(vPosition, 1.0);
  //position = vec3(uModelViewMatrix * vPosition4);
  
  texCoord = vTexCoord0;
  
  gl_Position = uModelViewProjectionMatrix * vPosition4;
}
""";
var fs =
"""
#ifdef GL_ES
precision mediump float;
#endif
//---------------------------------------------------------------------
// Uniform variables
//---------------------------------------------------------------------

/// The diffuse sampler.
uniform sampler2D uDiffuse;

/// The texture coodinate of the vertex.
varying vec2 texCoord;


void main() {
  vec4 color = texture2D(uDiffuse, texCoord);
  gl_FragColor = color;
}

""";

// Get the current model-view-projection matrix
//



// Multiply the projection matrix by the view matrix to combine them.
//
// The mathematical operators in Dart Vector Math will end up creating
// a new object. Rather than using * a self multiply is used. This is to
// avoid creating additional objects. As a general rule with a garbage
// collected language objects should be reused whenever possible.


// At this point we actually have the Model-View-Projection matrix. This
// is because the model matrix is currently the identity matrix. The model
// has no rotation, no scaling, and is sitting at (0, 0, 0).

// Copy the Model-View-Projection matrix into a Float32Array so it can be
// passed in as a constant to the ShaderProgram.



class RenderObject {
  /// [Float32Array] storage for the Model-View-Projection matrix.
  final Float32Array modelViewProjectionMatrixArray = new Float32Array(16);
  final vec3 position = new vec3.zero();
  final vec3 rotation = new vec3.zero();
  final vec3 scale = new vec3.zero();
  mat4 _modelViewProjectionMatrix = new mat4();
  SpectreMesh mesh;
  BlendState blendState;
  RasterizerState rasterState;
  DepthState depthState;
  SamplerState samplerState;
  Texture2D texture;

  ShaderProgram shader;
  InputLayout inputLayout;
  void update(Camera camera) {
    camera.copyProjectionMatrix(_modelViewProjectionMatrix);
    _modelViewProjectionMatrix.multiply(camera.viewMatrix);
    _modelViewProjectionMatrix.copyIntoArray(modelViewProjectionMatrixArray);
  }
}


class App extends GLApplication {
  MouseKeyboardCameraController _cameraController;

  SingleArrayIndexedMesh _boxRoom;
  InputLayout _layout;

  RasterizerState _rasterState;
  DepthState _depthState;

  BlendState _blendState;
  ShaderProgram _shader;
  RenderObject _boxes;
  bool textureLoaded = false;

  App(CanvasElement canvas) : super(canvas) {
    drawDebugInformation = true;

    // Create the CameraController and set the velocity of the movement
    _cameraController = new MouseKeyboardCameraController();
    _cameraController.forwardVelocity = 6.0;
    _cameraController.strafeVelocity = 20.0;
    _boxRoom = new SingleArrayIndexedMesh("BoxRom.mesh",graphicsDevice);


    _depthState = new DepthState.depthWrite('box.depth', graphicsDevice);
    _rasterState =  new RasterizerState("tile",graphicsDevice);
    _rasterState.cullMode = CullMode.None;

    _boxRoom.attributes["vPosition"] = new SpectreMeshAttribute(
        "vPosition",
        "float",
        3,
        0,
        20,
        false
    );
    _boxRoom.attributes["vTexCoord0"] = new SpectreMeshAttribute(
        "vTexCoord0",
        "float",
        2,
        12,
        20,
        false
    );
    var vertex = new Float32Array(120 * 5);
    var index = new Uint16Array(36 * 5);
    constructRect(new vec3(0,-2,0), new vec3(35,2,35),vertex,index,0,0,0);
    constructRect(new vec3(2,0,0), new vec3(33,20,2),vertex,index,120,24,36);
    constructRect(new vec3(0,0,0), new vec3(2,20,35),vertex,index,120*2,24*2,36*2);
    constructRect(new vec3(2,0,-33), new vec3(31,20,2),vertex,index,120*3,24*3,36*3);
    constructRect(new vec3(33,0,-2), new vec3(2,20,33),vertex,index,120*4,24*4,36*4);

    _boxRoom.vertexArray.uploadData(vertex, SpectreBuffer.UsageStatic);
    _boxRoom.indexArray.uploadData(index, SpectreBuffer.UsageStatic);
    _boxRoom.count = index.length;

    var shader = new ShaderProgram("default.shader", graphicsDevice);

    var vsS = new VertexShader("default.vs", graphicsDevice)
    ..source = vs
    ..compile();
    print(vsS.compileLog);
    var fsS = new FragmentShader("default.fs", graphicsDevice)
    ..source = fs
    ..compile();
    print(fsS.compileLog);
    shader.vertexShader = vsS;
    shader.fragmentShader = fsS;
    shader.link();

    _boxes = new RenderObject()
    ..mesh = _boxRoom
    ..shader = shader
    ..inputLayout = new InputLayout("default.input", graphicsDevice)
    ..blendState = new BlendState.alphaBlend("BoxRoom.blend", graphicsDevice);

    _boxes.inputLayout.shaderProgram = _boxes.shader;
    _boxes.inputLayout.mesh = _boxes.mesh;

    _boxes.samplerState = new SamplerState.linearClamp("default.state", graphicsDevice);
    _boxes.texture = new Texture2D("wood.texture", graphicsDevice);
    _boxes.texture.uploadFromURL("assets/textures/wood.png").then((val) {
      val.generateMipmap();
      textureLoaded = true;
    });

    start();
  }

  void onUpdate(double dt) {
    //debugDrawManager.addCross(new vec3(0,0,0), new vec4(1,0,1,1));
    //debugDrawManager.addCross(new vec3(1,0,1), new vec4(1,0,1,1));

    Keyboard keyboard = gameLoop.keyboard;
    _cameraController.forward     = keyboard.buttons[Keyboard.W].down;
    _cameraController.backward    = keyboard.buttons[Keyboard.S].down;
    _cameraController.strafeLeft  = keyboard.buttons[Keyboard.A].down;
    _cameraController.strafeRight = keyboard.buttons[Keyboard.D].down;

    if (gameLoop.pointerLock.locked) {
      Mouse mouse = gameLoop.mouse;

      _cameraController.accumDX = mouse.dx;
      _cameraController.accumDY = mouse.dy;
    }

    _cameraController.updateCamera(dt, camera);


    _boxes.update(camera);

  }

  /// Renders the application
  void onRender() {


    graphicsContext.setDepthState(_depthState);
    graphicsContext.setRasterizerState(_rasterState);
    graphicsContext.setInputLayout(_boxes.inputLayout);
    graphicsContext.setBlendState(_boxes.blendState);
    graphicsContext.setShaderProgram(_boxes.shader);
    graphicsContext.setPrimitiveTopology(GraphicsContext.PrimitiveTopologyTriangles);

    graphicsContext.setConstant("uModelViewMatrix", modelViewMatrixArray);
    graphicsContext.setConstant("uModelViewProjectionMatrix", _boxes.modelViewProjectionMatrixArray);
    graphicsContext.setConstant("uNormalMatrix", normalMatrixArray);
    if(textureLoaded == true) {
      graphicsContext.setTextures(0, [_boxes.texture]);
      graphicsContext.setSamplers(0, [_boxes.samplerState]);

    }


    graphicsContext.setIndexedMesh(_boxes.mesh);

    graphicsContext.drawIndexedMesh(_boxes.mesh);


  }
  void onResize(int width, int height) {

  }

}


//---------------------------------------------------------------------
// Global variables
//---------------------------------------------------------------------

/// Instance of the [Application].
App _app;

/// Identifier of the [CanvasElement] the application is rendering to.
final String _canvasId = '#backBuffer';


//---------------------------------------------------------------------
// GameLoop hooks
//---------------------------------------------------------------------






void main() {

  // Get the canvas
  CanvasElement canvas = query(_canvasId);
  _app = new App(canvas);
  _app.drawDebugInformation = true;
  _app.start();
}
