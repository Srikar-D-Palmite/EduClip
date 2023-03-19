import 'package:flutter/material.dart';

class VideoGrid extends StatelessWidget {
  const VideoGrid({
    super.key,
    required List<int> videoIndices,
  }) : _videoIndices = videoIndices;

  final List<int> _videoIndices;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      // The number of videos to display
      itemCount: _videoIndices.length,
      // The layout of the grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.47,
      ),
      // The widgets to display in the grid
      itemBuilder: (BuildContext context, int index) {
        // Return a blank video widget with a random number indicating the video index
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Video ${_videoIndices[index]}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}