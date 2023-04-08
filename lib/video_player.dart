import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class FullScreenVideoPlayer extends StatefulWidget {
  final List<String> videoUrls;
  final int index;
  FullScreenVideoPlayer(
      {super.key, required this.videoUrls, required this.index});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrls[index]);
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.play();
  }

  pausePlay() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
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
                  onTap: pausePlay,
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      // Swiped down, move to previous video
                      setState(() {
                        index = (index - 1);
                        if (index<0) {
                          index = widget.videoUrls.length-1;
                        }
                        final oldController = _controller;
                        _initializeVideoPlayer();
                        oldController.dispose();
                      });
                    } else {
                      // Swiped up, move to the next video
                      setState(() {
                        index = (index + 1) % widget.videoUrls.length;
                        final oldController = _controller;
                        _initializeVideoPlayer();
                        oldController.dispose();
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: _controller.value.size.height,
                        width: _controller.value.size.width,
                        child: VideoPlayer(_controller),
                      ),
                    ],
                  ),
                ),
              ))
            : Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: pausePlay,
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Icon(
          _controller.value.isPlaying ? 
          Icons.pause : 
          Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }
}
