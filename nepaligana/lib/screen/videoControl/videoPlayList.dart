import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:nepaligana/screen/videoControl/videoPlayer.dart';
import 'package:nepaligana/youtubePlayer/playYoutubeVideo.dart';

class videoList extends StatefulWidget {
  @override
  _videoListState createState() => _videoListState();
}

class _videoListState extends State<videoList> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Videos").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LiquidLinearProgressIndicator(
                  value: 0.5, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors
                      .pink), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.cyan,
                  borderWidth: 5.0,
                  borderRadius: 12.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text("Loading..."),
                ),
              );
            } else {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                children: snapshot.data.docs.map((document) {
                  return GestureDetector(
                    onTap: () {
                      print(document['videoUrl']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  playYoutubeVideo(document['videoUrl'])));
                    },
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: document['imageUrl'] != null
                                    ? NetworkImage(document['imageUrl'])
                                    : AssetImage("assets/nepaliGaana.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          document['videoName'] != null
                              ? document['videoName']
                              : "Video Name",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
