import 'package:edu_clip/grid_view.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  Explore({
    super.key,
  });

  // Random list of videos (to be changed later)
  final List<String> _videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://media.istockphoto.com/id/1449673113/video/drone-view-of-van-point-brittany-france.mp4?s=mp4-640x640-is&k=20&c=YSIrsLs9VdrGDbazjN74UMtKMXggD_x3VBgj7Lt-jpE=',
    'https://media.istockphoto.com/id/1435810600/video/hand-choosing-smile-face-from-emotion-block-customer-review-good-experience-positive-feedback.mp4?s=mp4-640x640-is&k=20&c=6qpiKhW8PxrvX5Me9dQSZUaveVFhVYatIWAN-PvlEG0=',
    'https://media.istockphoto.com/id/1410075891/video/aerial-shot-of-the-verdon-gorge-in-provence-france.mp4?s=mp4-640x640-is&k=20&c=BJ8P1a-NpK_4hNKA5qQ8YtRLg22DxMuoFSayvSFeEyk=',
    'https://media.istockphoto.com/id/1380176517/video/picturesque-white-mountain-slopes-covered-with-pine-forests-and-skiing-pistes-and-moving.mp4?s=mp4-640x640-is&k=20&c=nq_sMpw-d103WEDzM2LSLkxLIpRa7sGeL2dcL2RFd3w=',
    'https://media.istockphoto.com/id/1410582936/video/flamingo.mp4?s=mp4-640x640-is&k=20&c=z77sqHUh6JF-_BZiTzUolBz0uNITJjEPfxbv95cRqC4=',

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
                  hintStyle: const TextStyle(
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
