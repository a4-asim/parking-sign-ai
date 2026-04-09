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
  bool isAnalyzing = false;

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

  void retakePicture() {
    setState(() {
      image = null;
    });
  }

  Future<void> analyzeImage() async {
    setState(() {
      isAnalyzing = true;
    });
    
    // Simulate analysis delay
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      isAnalyzing = false;
    });
    
    // Show results dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Analysis Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text(
              'No Parking 9 AM - 5 PM',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Monday to Friday',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              retakePicture();
            },
            child: Text('Retake'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0066CC),
          title: Text('Initializing Camera...'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF0066CC)),
              SizedBox(height: 16),
              Text('Loading camera...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0066CC),
        title: Text('Scan Parking Sign'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Camera Preview or Image
          image == null
              ? CameraPreview(controller!)
              : Container(
                  color: Colors.black,
                  child: Center(
                    child: Image.file(File(image!.path)),
                  ),
                ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.all(24),
              child: image == null
                  ? Column(
                      children: [
                        Text(
                          'Align parking sign in frame',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0066CC), width: 3),
                          ),
                          child: FloatingActionButton(
                            onPressed: takePicture,
                            backgroundColor: Color(0xFF0066CC),
                            child: Icon(Icons.camera_alt, size: 32),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        isAnalyzing
                            ? Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Analyzing parking sign...',
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: retakePicture,
                                    icon: Icon(Icons.refresh),
                                    label: Text('Retake'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade700,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: analyzeImage,
                                    icon: Icon(Icons.search),
                                    label: Text('Analyze'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0066CC),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
            ),
          ),

          // Top guidance overlay
          if (image == null)
            Positioned(
              top: 80,
              left: 50,
              right: 50,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF0066CC), width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF0066CC).withOpacity(0.1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}