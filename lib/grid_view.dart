import 'package:flutter/material.dart';
import 'video_player.dart';
import 'package:video_player/video_player.dart';

class VideoGrid extends StatefulWidget {
  const VideoGrid({
    super.key,
    required List<String> videoUrls,
  }) : _videoUrls = videoUrls;

  final List<String> _videoUrls;

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late List<VideoPlayerController> _controllers;
  
  @override
  void initState() {
    super.initState();
    // initialize the video players
    _controllers = widget._videoUrls
        .map((url) => VideoPlayerController.network(url))
        .toList();
    // initialize all the controllers and wait for them to load
    Future.wait(_controllers.map((controller) => controller.initialize())).then((value) => setState(() {}));
    // setState(() {});
  }

  @override
  void dispose() {
    // dispose all the video players when the widget is disposed
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      // The number of videos to display
      itemCount: widget._videoUrls.length,
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
                videoUrls: widget._videoUrls,
                index: index,
              ),
            ),
          ),
          // upon loading all the videos, display them
          child:_controllers[index].value.isInitialized
            ?  ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                child: SizedBox(
                  height: _controllers[index].value.size.height,
                  width: _controllers[index].value.size.width,
                  child: VideoPlayer(_controllers[index]),
                ),
              ),
          ) :
          LinearProgressIndicator(
            backgroundColor: Colors.grey[100],
            color: Colors.grey[200],
          )
        );
      },
    );
  }
}
