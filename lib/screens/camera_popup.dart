import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golheal_app/controllers/category_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'dart:math' as math;

class CameraPopup extends StatefulWidget {
  final int brandId;
  final CategoryController categoryController;

  CameraPopup({required this.brandId, required this.categoryController});

  @override
  _CameraPopupState createState() => _CameraPopupState();
}

class _CameraPopupState extends State<CameraPopup> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _isFaceDetected = false;
  bool _isLoading = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableTracking: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    if (!mounted) return;

    setState(() {});

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _detectFaces(image);
      }
    });
  }

  Future<void> _detectFaces(CameraImage image) async {
    if (_isFaceDetected) return;

    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    // final rotation = _cameraController!.description.lensDirection == CameraLensDirection.front
    //     ? InputImageRotation.rotation0deg
    //     : InputImageRotation.rotation180deg;
    final InputImageMetadata metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      // rotation: rotation,
      rotation: InputImageRotation.rotation90deg,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: metadata,
    );

    _isDetecting = true;
    final faces = await _faceDetector.processImage(inputImage);
    print("Number of faces detected: ${faces.length}");

    if (faces.isNotEmpty) {
      _isFaceDetected = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khuôn mặt đã được phát hiện!')),
      );
      _takePictureAndSendToBackend();
    }

    _isDetecting = false;
  }

  Future<void> _takePictureAndSendToBackend() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile picture = await _cameraController!.takePicture();
      File imageFile = File(picture.path);

      if (imageFile.existsSync()) {
        await widget.categoryController.fetchCategoriesByImageAndBrandId(imageFile, widget.brandId);
        widget.categoryController.update();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nhận dữ liệu thành công!'),
            duration: Duration(seconds: 2), // Thời gian hiển thị
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra khi nhận dữ liệu: $e'),
          duration: Duration(seconds: 2), // Thời gian hiển thị
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Dialog(
      child: OrientationBuilder(
        builder: (context, orientation) {
          double rotationAngle = 0;

          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            rotationAngle = math.pi / 2;
          }
          return Transform.rotate(
            angle: rotationAngle,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: CameraPreview(_cameraController!),
                  ),
                  Positioned(
                    top: 10,
                    // right: 260,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
