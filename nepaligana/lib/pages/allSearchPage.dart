import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepaligana/screen/singleAudioPlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchAll extends StatefulWidget {
  @override
  _SearchAllState createState() => _SearchAllState();
}

class _SearchAllState extends State<SearchAll> {
  String userid;
  TextEditingController searchBarController=TextEditingController();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Among 50K+ Music",
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Search Music",
                style: GoogleFonts.aBeeZee(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                color: Colors.white60,
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: searchBarController,
                    style:
                        GoogleFonts.aBeeZee(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Search Your Songs Title ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),


                      prefixIcon: Icon(
                        Icons.search_sharp,
                        color: Colors.black,
                        size: 40,
                      ),
                      suffixIcon: IconButton(icon: Icon(Icons.clear_rounded,
                      color: Colors.black,
                      size: 40,
                      
                      ), onPressed: (){
                        setState(() {
                          searchBarController.text="";
                        });
                      })
                    ),

                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream:searchBarController.text==""? FirebaseFirestore.instance
                    .collection("AllMusic")
                    .snapshots():FirebaseFirestore.instance
                    .collection("AllMusic").where("title",isEqualTo: searchBarController.text)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        return GestureDetector(
                          onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>singleAudioPlayer("AllMusic",document.id)));
                          },
                                                  child: Card(
                            elevation: 0,
                            child: Container(
                              height: 70,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: document['imageUrl'] != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    document['imageUrl']),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : Image.asset("assets/dance.jpg"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: document['title'] != null
                                          ? Text(
                                              document['title'],
                                              style: GoogleFonts.aBeeZee(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            )
                                          : Text("Song Title")),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.play_circle_fill_sharp,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.play_arrow_outlined,
                                          color: Colors.cyan,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
