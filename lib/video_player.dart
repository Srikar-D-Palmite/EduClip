import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class FullScreenVideoPlayer extends StatefulWidget {
  final List<QueryDocumentSnapshot<Object?>> videos;
  final int index;
  const FullScreenVideoPlayer(
      {super.key, required this.videos, required this.index});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  late int _index;
  late bool _upvoted = false;
  late bool _downvoted = false;
  late int _upvotes = 0;
  late int _downvotes = 0;
  late DocumentReference<Map<String, dynamic>> _userDoc;
  late DocumentReference<Map<String, dynamic>> _videoDoc;
  final double _iconSize = 24;
  bool _textVisible = false;
  late String _videoTitle;

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _videoTitle = "";
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer([bool loop = true]) {
    FirebaseFirestore.instance
        .collection("users")
        .where(FieldPath.documentId,
            isEqualTo: widget.videos[_index]['authorId'])
        .get()
        .then((value) => setState(() {
              _videoTitle = value.docs[0]['username'];
            }));

    _videoDoc = FirebaseFirestore.instance
        .collection("videos")
        .doc(widget.videos[_index].id);

    User? user = FirebaseAuth.instance.currentUser;

    _userDoc = FirebaseFirestore.instance.collection("users").doc(user!.uid);

    _videoDoc.get().then((value) {
      setState(() {
        _upvotes = value.data()!["upvotes"];
        _downvotes = value.data()!["downvotes"];
      });
    });

    _userDoc.get().then((value) {
      bool upv = false;
      bool dov = false;

      for (var vid in value.data()!["upvotedVideos"]) {
        if (vid == _videoDoc.id) {
          upv = true;
        }
      }

      for (var vid in value.data()!["downvotedVideos"]) {
        if (vid == _videoDoc.id) {
          dov = true;
        }
      }

      setState(() {
        _upvoted = upv;
        _downvoted = dov;
      });
    });

    _controller = VideoPlayerController.network(widget.videos[_index]['url']);
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
    _initializeVideoPlayer();
    oldController.dispose();
  }

  void _onVideoPlayerUpdate() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    if (position >= duration && _controller.value.isInitialized) {
      print("Video player update: $position >= $duration");
      setState(() {
        _index = (_index + 1) % widget.videos.length;
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
    String videoDescription = widget.videos[_index]['description'];

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
                                _index = widget.videos.length - 1;
                              }
                              _updateVideoPlayer();
                            });
                          } else {
                            // Swiped up, move to the next video
                            setState(() {
                              _index = (_index + 1) % widget.videos.length;
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
          // Author
          Positioned(
            top: 0,
            left: 0,
            child: Container(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Row(children: [
                  CircleAvatar(
                    radius: 25.0,
                    // to replace with user profile image
                    // backgroundImage: AssetImage('/images/avatar.png'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(_videoTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 15))
                ])),
          ),
          // Description
          Positioned(
              left: 0,
              bottom: 0,
              width: 300,
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, bottom: 80),
                  child: TextButton(
                      onPressed: () => {
                            setState(() {
                              _textVisible = !_textVisible;
                            })
                          },
                      child: Text(videoDescription,
                          maxLines: _textVisible ? 3 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white))))),
          // Icons
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
                    if (_upvoted) {
                      setState(() {
                        _videoDoc.update({"upvotes": FieldValue.increment(-1)});
                        _userDoc.update({
                          "upvotedVideos":
                              FieldValue.arrayRemove([_videoDoc.id])
                        });
                        _upvotes--;
                        _upvoted = false;
                      });

                      return;
                    }
                    _userDoc.update({
                      "upvotedVideos": FieldValue.arrayUnion([_videoDoc.id])
                    });
                    setState(() {
                      _videoDoc.update({"upvotes": FieldValue.increment(1)});
                      if (_downvoted) {
                        _videoDoc
                            .update({"downvotes": FieldValue.increment(-1)});
                        _userDoc.update({
                          "downvotedVideos":
                              FieldValue.arrayRemove([_videoDoc.id])
                        });
                        _downvotes--;
                      }
                      _upvotes++;
                      _upvoted = true;
                      _downvoted = false;
                    });
                  },
                  icon: const ColumnIcon(icon: Icons.arrow_upward),
                  color: Colors.white,
                  iconSize: _iconSize,
                ),
                Text(
                  "${_upvotes - _downvotes}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  highlightColor: Colors.red,
                  onPressed: () {
                    if (_downvoted) {
                      setState(() {
                        _videoDoc
                            .update({"downvotes": FieldValue.increment(-1)});
                        _userDoc.update({
                          "downvotedVideos":
                              FieldValue.arrayRemove([_videoDoc.id])
                        });
                        _downvotes--;
                        _downvoted = false;
                      });

                      return;
                    }
                    _userDoc.update({
                      "downvotedVideos": FieldValue.arrayUnion([_videoDoc.id])
                    });
                    setState(() {
                      _videoDoc.update({"downvotes": FieldValue.increment(1)});
                      if (_upvoted) {
                        _videoDoc.update({"upvotes": FieldValue.increment(-1)});
                        _userDoc.update({
                          "upvotedVideos":
                              FieldValue.arrayRemove([_videoDoc.id])
                        });
                        _upvotes--;
                      }
                      _downvotes++;
                      _downvoted = true;
                      _upvoted = false;
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
      shadows: const <Shadow>[
        Shadow(color: Color.fromARGB(255, 13, 13, 13), blurRadius: 5.0)
      ],
    );
  }
}
