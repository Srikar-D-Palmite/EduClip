import 'package:edu_clip/grid_view.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  Explore({
    super.key,
  });

  // Random list of videos (to be changed later)
  final List<String> _videoUrls =[
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/rooster.mp4',
  ];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Can also be implemented with appBar instead of a column + Container
        child: Column(
          children: [
            const SizedBox(height: 15),
            // Search bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              // decoration: BoxDecoration(
              //   color: Colors.grey[200],
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  // The word "search" in the searchbox
                  hintText: 'Search',
                  hintStyle:const TextStyle(
                    color: Colors.grey,
                    // fontWeight: FontWeight.w500,
                  ),
                  // the search icon
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.black,
                  // the delete text icon
                  suffixIcon: IconButton(
                    onPressed: _controller.clear,
                    icon: const Icon(Icons.close),
                    iconSize: 18,
                  ),
                  suffixIconColor: Colors.black,
                  // padding around the text (affects the size of the searchbox)
                  contentPadding: const EdgeInsets.all(5.0),
                  // defining the border normally, and when focused (pressed on)
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      // width: 3,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      // width: 3,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                // border: InputBorder.none,
              ),
            ),
            // Spacing after search box. Documentation provided by Srikar T.
            const SizedBox(height: 10),
            // grid of videos
            Expanded(
              child: VideoGrid(videoUrls: _videoUrls),
            ),
          ],
        ),
        ),
    );
  }
}