// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// class CameraScreen extends StatefulWidget {
//   static String routName = 'CameraScreen';
//
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   late List<CameraDescription> cameras;
//   String answer = "";
//   CameraController? cameraController;
//   CameraImage? cameraImage;
//
//   loadModel() async {
//     Tflite.loadModel(
//       model: "assets/detect.tflite",
//       labels: "assets/labels.txt",
//     );
//     print("model loaded");
//   }
//
//   initCamera() async {
//     cameras = await availableCameras();
//     print("cameras: $cameras\n");
//     if (cameras.isNotEmpty) {
//       cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     }
//
//     cameraController!.initialize().then(
//           (value) {
//         if (!mounted) {
//           return;
//         }
//         setState(
//               () {
//             cameraController!.startImageStream(
//                   (image) => {
//                 cameraImage = image,
//                 applyModelOnImage(),
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   applyModelOnImage() async {
//     if (cameraImage != null) {
//       //print(cameraImage);
//       var predictions = await Tflite.runModelOnFrame(
//           bytesList: cameraImage!.planes.map(
//                 (plane) {
//               return plane.bytes;
//             },
//           ).toList(),
//           imageHeight: cameraImage!.height,
//           imageWidth: cameraImage!.width,
//           imageMean: 127.5,
//           imageStd: 127.5,
//           rotation: 90,
//           numResults: 3,
//           threshold: 0.1,
//           asynch: true);
//
//       answer = '';
//       predictions!.forEach(
//             (prediction) {
//           answer =   prediction['label'].toString().substring(1);
//
//           // prediction['label'].toString().substring(0, 1).toUpperCase() +
//           //     prediction['label'].toString().substring(1) +
//           //     " " +
//           //     (prediction['confidence'] as double).toStringAsFixed(3) +
//           //     '\n';
//         },
//       );
//
//       setState(
//             () {
//           answer = answer;
//         },
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//     loadModel();
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     await Tflite.close();
//     cameraController!.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme:
//       ThemeData(brightness: Brightness.dark, primaryColor: Colors.purple),
//       debugShowCheckedModeBanner: false,
//       home: SafeArea(
//         child: Scaffold(
//           body: cameraImage != null
//               ? Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             color: Colors.blue,
//             child: Stack(
//               children: [
//                 Positioned(
//                   child: Center(
//                     child: Container(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: AspectRatio(
//                         aspectRatio: cameraController!.value.aspectRatio,
//                         child: CameraPreview(
//                           cameraController!,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       color: Colors.black87,
//                       child: Center(
//                         child: Text(
//                           answer,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 20, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//               : Container(),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter/foundation.dart';

class CameraScreen extends StatefulWidget {
  static String routName = 'CameraScreen';

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

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController!.dispose();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/detect.tflite",
      labels: "assets/labels.txt",
    );
    print("model loaded");
  }

  initCamera() async {
    cameras = await availableCameras();
    print("cameras: $cameras\n");
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras[isFrontCamera ? 1 : 0],
        ResolutionPreset.medium,
      );
    }

    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((image) {
          _frameCount++;
          if (!_isProcessing && _frameCount % 10 == 0) {  // Process every 10th frame
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
      setState(() {
        _isProcessing = true;
      });

      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 3,
        threshold: 0.1,
        asynch: true,
      );

      setState(() {
        if (predictions != null && predictions.isNotEmpty) {
          answer = predictions[0]['label'].toString().substring(1);
        } else {
          answer = '';
        }
        _isProcessing = false;
      });
    }
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
          body: cameraImage != null
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
              : Container(),
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