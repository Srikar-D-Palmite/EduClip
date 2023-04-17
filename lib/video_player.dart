import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'settings.dart';

/// Stateful widget to fetch and then display video content.
class FullScreenVideoPlayer extends StatefulWidget {
  final List<String> videoUrls;
  final int index;
  FullScreenVideoPlayer(
      {super.key, required this.videoUrls, required this.index});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  late int index;
  int _upvotes = 5;
  int _downvotes = 5;
  int _favorite = 5;
  double _iconSize = 24;

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

  void _initializeVideoPlayer([bool loop = true]) {
    _controller = VideoPlayerController.network(widget.videoUrls[index]);
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    _controller.setLooping(loop);
    _controller.play();
  }

  pausePlay() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final settings = SettingsProvider.of(context).settings;
    // if (_controller.value.duration - _controller.value.position < Duration(seconds: 1)) {
    //   setState(() {
    //     index = (index + 1) % widget.videoUrls.length;
    //     final oldController = _controller;
    //     _initializeVideoPlayer();
    //     oldController.dispose();
    //   });
    // }
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
                        if (index < 0) {
                          index = widget.videoUrls.length - 1;
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
                        // width: 20,
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        // width: 300,
                        child: SizedBox(
                          // width: 300,
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: Transform.scale(
                            scale: 0.6,
                            alignment: Alignment(0, 1.0),
                            child: Container(
                              // color: Colors.black.withOpacity(0.5),
                              padding: EdgeInsets.only(left: 230),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _favorite++;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.more_vert,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color:
                                                Color.fromARGB(255, 13, 13, 13),
                                            blurRadius: 5.0)
                                      ],
                                    ),
                                    color: Colors.white,
                                    iconSize: _iconSize,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _upvotes++;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_upward,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color:
                                                Color.fromARGB(255, 13, 13, 13),
                                            blurRadius: 5.0)
                                      ],
                                    ),
                                    color: Colors.white,
                                    iconSize: _iconSize,
                                  ),
                                  Text(
                                    '$_upvotes',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    highlightColor: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        _upvotes--;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_downward_outlined,
                                      // opticalSize: 40.0,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color:
                                                Color.fromARGB(255, 13, 13, 13),
                                            blurRadius: 5.0)
                                      ],
                                    ),
                                    color: Colors.white,
                                    iconSize: _iconSize,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.comment,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color:
                                                Color.fromARGB(255, 13, 13, 13),
                                            blurRadius: 5.0)
                                      ],
                                    ),
                                    color: Colors.white,
                                    iconSize: _iconSize,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.share,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color:
                                                Color.fromARGB(255, 13, 13, 13),
                                            blurRadius: 5.0)
                                      ],
                                    ),
                                    color: Colors.white,
                                    iconSize: _iconSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }
}
