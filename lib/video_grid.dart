import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoGrid extends StatefulWidget {
  const VideoGrid({
    super.key,
    required List<String> videoKeys,
  }) : _videoKeys = videoKeys;

  final List<String> _videoKeys;

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late List<Future<VideoPlayerController>> _controllers;
  late List<VideoPlayerController?> _snapshotControllers;
  late List<QueryDocumentSnapshot<Object?>> _videos;
  // late FirebaseFirestore _db;
  late Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot;

  @override
  void initState() {
    super.initState();
    // Create a list of video Urls to display
    // _db = FirebaseFirestore.instance;
    _videos = [];
    _controllers = [];
    _snapshotControllers = [];
    getVideos();
  }

  @override
  void dispose() {
    // dispose all the video players when the widget is disposed
    // _controllers.forEach((controller) => controller.dispose());
    // _snapshotControllers.forEach((controller) => controller.dispose());
    _videos.clear();
    super.dispose();
  }

  void getVideos() async {
    try {
      // I previously incorrectly used url whereIn widget._videoKeys. We query the database for the video urls with the given document ids (keys)
      querySnapshot = FirebaseFirestore.instance
          .collection("videos")
          .where(FieldPath.documentId, whereIn: widget._videoKeys)
          .get();
      setState(() {});
    } catch (e) {
      print('Error loading videos: $e');
    }
  }

  void fillUrls(QuerySnapshot snapshot) {
    for (var i = 0; i < widget._videoKeys.length; i++) {
      for (var doc in snapshot.docs) {
        _videos.add(doc);
      }
    }
  }

  Future<VideoPlayerController> loadController(index) async {
    QueryDocumentSnapshot<Object?> video = _videos[index];
    final controller = VideoPlayerController.network(video['url']);
    try {
      await controller.initialize();
    } on PlatformException catch (e) {
      // TODO: Failed to load video
    }
    return controller;
  }

  Widget _buildVideoPlayer(int index) {
    _controllers.add(loadController(index));
    return FutureBuilder(
      // indexing is difficult because the list is not initialized yet
      future: _controllers[index],
      builder: (context, snapshot) {
        _snapshotControllers.add(snapshot.data);
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final controller = snapshot.data;
          if (controller == null || !controller.value.isInitialized) {
            return LinearProgressIndicator(
              backgroundColor: Colors.grey[100],
              color: Colors.grey[200],
            );
          }
          // Thumbnail of video. Clicking on it will play open the video player
          return ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: SizedBox(
                height: controller.value.size.height,
                width: controller.value.size.width,
                child: VideoPlayer(controller),
              ),
            ),
          );
        } else {
          // Show loading while the video controller is being initialized
          return LinearProgressIndicator(
            backgroundColor: Colors.grey[100],
            color: Colors.grey[200],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Text("${widget._videoKeys.length} results found:",);
    return FutureBuilder<QuerySnapshot>(
        future: querySnapshot,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data.docs.length > 0) {
            fillUrls(snapshot.data);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              // The number of videos to display
              itemCount: widget._videoKeys.length,
              // The layout of the grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.47,
              ),
              // The widgets to display in the grid
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  // upon tapping a video, navigate to the full screen video player
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenVideoPlayer(
                        videos: _videos,
                        index: index,
                      ),
                    ),
                  ),
                  // upon loading all the videos, display them
                  child: _buildVideoPlayer(index),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
