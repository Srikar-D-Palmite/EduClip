import 'package:edu_clip/video_grid.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Explore extends StatefulWidget {
  Explore({
    super.key,
  });

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // late Reference storageRef;
  // Reference? imagesRef;
  late FirebaseFirestore db;
  late List<String> _videoKeys = [];
  late Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // pointer to storage
    // storageRef = FirebaseStorage.instance.ref();
    // imagesRef = storageRef.child("videos");
    db = FirebaseFirestore.instance;
    getVideos();
  }

  void getVideos() async {
    try {
      querySnapshot = FirebaseFirestore.instance.collection("videos").get();
    } catch (e) {
      print('Error loading videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Can also be implemented with appBar instead of a column + Container
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 15),
                // Search bar
                SearchBar(controller: _controller),
                // Spacing after search box. Documentation provided by Srikar T.
                const SizedBox(height: 10),
                // Text("${_videoKeys.length} results found: ${_videoKeys[0]}",),
              ],
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: querySnapshot,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      snapshot.data!.docs.forEach((DocumentSnapshot doc) async {
                        _videoKeys.add(doc.id);
                      });
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            // grid of videos
                            VideoGrid(videoKeys: _videoKeys),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
