import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  XFile? image;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
    setState(() {});
  }

  Future<void> takePicture() async {
    final img = await controller!.takePicture();
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Camera")),
      body: Column(
        children: [
          Expanded(
            child: image == null
                ? CameraPreview(controller!)
                : Image.file(File(image!.path)),
          ),
          ElevatedButton(
            onPressed: takePicture,
            child: Text("Capture"),
          ),
        ],
      ),
    );
  }
}