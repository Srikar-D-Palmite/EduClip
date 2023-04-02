import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideoPlayer({super.key, required this.videoUrl});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? SizedBox.expand(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              )
            : Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}