import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class FullScreenVideoPlayer extends StatefulWidget {
  final List<String> videoUrls;
  final int index;
  const FullScreenVideoPlayer(
      {super.key, required this.videoUrls, required this.index});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  late int _index;
  int _upvotes = 5;
  final double _iconSize = 24;
  bool _textVisible = false;

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer([bool loop = true]) {
    _controller = VideoPlayerController.network(widget.videoUrls[_index]);
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    _controller.setLooping(loop);
    _controller.play();
    _controller.addListener(_onVideoPlayerUpdate);
  }

  void _updateVideoPlayer() {
    final oldController = _controller;
    _controller = VideoPlayerController.network(widget.videoUrls[_index]);
    _controller.initialize().then((_) {
      setState(() {});
      // oldController.removeListener(_onVideoPlayerUpdate);
      // _controller.addListener(_onVideoPlayerUpdate);
    });
    _controller.setLooping(true);
    _controller.play();
    oldController.dispose();
  }

  void _onVideoPlayerUpdate() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    if (position >= duration && _controller.value.isInitialized) {
      print("Video player update: $position >= $duration");
      setState(() {
        _index = (_index + 1) % widget.videoUrls.length;
        _updateVideoPlayer();
      });
    }
  }

  pausePlay() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: GestureDetector(
                        onTap: pausePlay,
                        onVerticalDragEnd: (details) {
                          double velocity = details.velocity.pixelsPerSecond.dy;
                          if (velocity > 0) {
                            // Swiped down, move to previous video
                            setState(() {
                              _index = (_index - 1);
                              if (_index < 0) {
                                _index = widget.videoUrls.length - 1;
                              }
                              _updateVideoPlayer();
                            });
                          } else {
                            // Swiped up, move to the next video
                            setState(() {
                              _index = (_index + 1) % widget.videoUrls.length;
                              _updateVideoPlayer();
                            });
                          }
                        },
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: CircleAvatar(
                  radius: 25.0,
                  // to replace with user profile image
                  // backgroundImage: AssetImage('/images/avatar.png'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                )),
          ),
          Positioned(
              left: 0,
              bottom: 0,
              width: 300,
              child: Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 80),
                  child: TextButton(
                      onPressed: () => {
                            setState(() {
                              _textVisible = !_textVisible;
                            })
                          },
                      child: Text("Herd of flamingos",
                          maxLines: _textVisible ? 3 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white))))),
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const ColumnIcon(icon: Icons.more_vert),
                  color: Colors.white,
                  iconSize: _iconSize,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _upvotes++;
                    });
                  },
                  icon: const ColumnIcon(icon: Icons.arrow_upward),
                  color: Colors.white,
                  iconSize: _iconSize,
                ),
                Text(
                  '$_upvotes',
                  style: const TextStyle(
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
                  icon: const ColumnIcon(icon: Icons.arrow_downward),
                  color: Colors.white,
                  iconSize: _iconSize,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const ColumnIcon(icon: Icons.comment),
                  color: Colors.white,
                  iconSize: _iconSize,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const ColumnIcon(icon: Icons.share),
                  color: Colors.white,
                  iconSize: _iconSize,
                ),
              ],
            ),
          ),
        ],
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

class ColumnIcon extends StatelessWidget {
  const ColumnIcon({
    super.key,
    required IconData icon,
  }) : _icon = icon;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icon,
      shadows: <Shadow>[
        Shadow(color: Color.fromARGB(255, 13, 13, 13), blurRadius: 5.0)
      ],
    );
  }
}
