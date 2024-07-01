import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:async';

class CameraScreen extends StatefulWidget {
  static String routeName = 'CameraScreen';

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  String answer = "";
  CameraController? cameraController;
  CameraImage? cameraImage;
  bool isFrontCamera = false;
  bool isFlashOn = false;
  bool _isProcessing = false;
  int _frameCount = 0;
  Completer<void>? _modelRunningCompleter;

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/detect.tflite",
      labels: "assets/labels.txt",
    );
    print("Model loaded");
  }

  initCamera() async {
    cameras = await availableCameras();
    print("Cameras: $cameras\n");
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras[isFrontCamera ? 1 : 0],
        ResolutionPreset.max,
      );
    }

    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((image) {
          _frameCount++;
          if (_frameCount % 1 == 0) {  // Process every 10th frame
            cameraImage = image;
            applyModelOnImage();
          }
        });
      });
    });
  }

  switchCamera() async {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    await cameraController?.dispose();
    initCamera();
  }

  toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    cameraController!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  applyModelOnImage() async {
    if (cameraImage != null && !_isProcessing) {
      if (_modelRunningCompleter != null && !_modelRunningCompleter!.isCompleted) {
        return;
      }
      _modelRunningCompleter = Completer<void>();

      _isProcessing = true;

      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 7,
          threshold: 0.1,
          asynch: true,
        );

        if (!mounted) return;

        setState(() {
          if (predictions != null && predictions.isNotEmpty) {
            // Display all predictions
            answer = predictions[0]['label'].toString().substring(1);
          } else {
            answer = '';
          }
        });
      } finally {
        _isProcessing = false;
        _modelRunningCompleter!.complete();
      }
    }
  }

  void closeCamera() async {
    if (_modelRunningCompleter != null && !_modelRunningCompleter!.isCompleted) {
      await _modelRunningCompleter!.future;
    }
    await cameraController?.dispose();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Camera Screen'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: closeCamera,
            ),
          ),
          body: cameraController != null && cameraController!.value.isInitialized
              ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: Stack(
              children: [
                Positioned(
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.black87,
                      child: Center(
                        child: Text(
                          answer,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              : Center(child: CircularProgressIndicator()),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'switchCamera',
                onPressed: switchCamera,
                child: Icon(Icons.switch_camera),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'toggleFlash',
                onPressed: toggleFlash,
                child: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
