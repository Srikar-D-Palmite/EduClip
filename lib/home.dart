import 'package:edu_clip/video_list.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseFirestore db;
  late List<String> _videoKeys = [];
  late Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                            VideoList(videoKeys: _videoKeys),
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