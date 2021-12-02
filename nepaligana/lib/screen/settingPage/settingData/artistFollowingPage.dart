import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepaligana/screen/audioPlayer.dart';

class artistFollowing extends StatefulWidget {
  @override
  _artistFollowingState createState() => _artistFollowingState();
}

class _artistFollowingState extends State<artistFollowing> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Artist Followed",
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        leading: BackButton(color: Colors.black,),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Artist").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.count(
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                children: snapshot.data.docs.map((document) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => audioPlayerPage(
                                  "Artist/" + document.id + "/Music")));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                            image: DecorationImage(
                              image: document['image'] != null
                                  ? NetworkImage(document['image'])
                                  : AssetImage("assets/artistProfile.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          document['Name'] != null
                              ? document['Name']
                              : "Artist Name",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // follower
                        Text(
                          document['Fwolling'] != null
                              ? document['Fwolling']
                              : "Artist Follower",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
