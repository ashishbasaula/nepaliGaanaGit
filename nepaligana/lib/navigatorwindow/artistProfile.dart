import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepaligana/screen/audioPlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class artistProfile extends StatefulWidget {
  @override
  _artistProfileState createState() => _artistProfileState();
}

class _artistProfileState extends State<artistProfile> {
  var userid;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharePref();
  }

  void getsharePref() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      userid = _pref.getString("userId");
      print(userid);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Artist").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((document) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
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
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
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
                      Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue.shade600,
                        ),
                        child: Row(
                          children: [
                            TextButton(
                           
                              onPressed: () async{
                               await FirebaseFirestore.instance.collection("userProfile").doc(userid).collection("followingArtist").where("docId",isEqualTo: document.id).get().then((value) {
if(value.docs.isEmpty)
{
 FirebaseFirestore.instance.collection("userProfile").doc(userid).collection("followingArtist").add({
   "image":document['image'],
   "name":document['Name'],
   "docId":document.id,
 }).then((value){
Fluttertoast.showToast(msg: "You Started Following"+document['Name']);
 });
}            else{
  Fluttertoast.showToast(msg: "Already Following  "+document['Name']);
}                   });
                              },
                              child: Text("Follow",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                              
                              ),
                            ),
                            Container(
height: 40,
width: 2,
color: Colors.white,
                            ),
                            SizedBox(
width: 3,
                            ),
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
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
