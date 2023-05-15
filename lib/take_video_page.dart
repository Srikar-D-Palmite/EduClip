import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class TakeVideoPage extends StatefulWidget {
  final CameraController controller;

  const TakeVideoPage({required this.controller});

  @override
  _TakeVideoPageState createState() => _TakeVideoPageState();
}

class _TakeVideoPageState extends State<TakeVideoPage> {
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = widget.controller.initialize();
  }

  @override
  void dispose() {
    _stopVideoRecording().then((_) {
      widget.controller.dispose();
    });
    super.dispose();
  }

  Future<void> _stopVideoRecording() async {
    if (!widget.controller.value.isRecordingVideo) {
      return;
    }

    try {
      await widget.controller.stopVideoRecording();
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Video'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(widget.controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            if (widget.controller.value.isRecordingVideo) {
              await _stopVideoRecording();
              Navigator.pop(context);
            } else {
              await widget.controller.startVideoRecording();
            }
          } catch (e) {
            print('Error starting video recording: $e');
          }
        },
        child: Icon(
          widget.controller.value.isRecordingVideo
              ? Icons.stop
              : Icons.fiber_manual_record,
        ),
      ),
    );
  }
}
