import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepaligana/screen/settingPage/getLocalMusic.dart';
import 'settingData/allDownloadedList.dart';
import 'settingData/myLikeSong.dart';
import 'settingData/myPlayList.dart';
import 'settingData/artistFollowingPage.dart';
class myLibrary extends StatefulWidget {
  @override
  _myLibraryState createState() => _myLibraryState();
}

class _myLibraryState extends State<myLibrary> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Library",
                style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 20),
              ),
            ),
            Divider(
              color: Colors.red,
              height: 10,
              thickness: 2,
            ),
           settingDesigne(title: "Downloaded Song",imageUrl: "assets/downlodIcon.png",onTap: (){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>downloadedList()));
           }),
           // your Like Song 
             settingDesigne(title: "Like Song",imageUrl: "assets/allSong.png",onTap: (){
 Navigator.push(context, MaterialPageRoute(builder: (context)=>likeSongs()));
           }),
           // my playlist song 
           settingDesigne(title: "PlayList Song",imageUrl: "assets/playlist.png",onTap: (){
 Navigator.push(context, MaterialPageRoute(builder: (context)=>playList()));
           }),
         
           // this is my artist followed list 
                settingDesigne(title: "Artist Followed",imageUrl: "assets/artistFollowing.png",onTap: (){
 Navigator.push(context, MaterialPageRoute(builder: (context)=>artistFollowing()));
           }),
// memory card Song 
SizedBox(
height: 10,
),
 Padding(
   padding: const EdgeInsets.all(8.0),
   child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Local Song",
                  style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 20),
                ),
              ),
 ),
            Divider(
              color: Colors.red,
              height: 10,
              thickness: 2,
              
            ),
ListTile(
  onTap: (){
    print("this is all List of all Song in my memory Card");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAudioList()));
  },
title:Text(
                  "Memory Card",
                  style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 20),
                ), 
                trailing: Icon(Icons.arrow_right_outlined,
                  color: Colors.black,
                  size: 50,
                  ),
),
          ],
        ),
      ),
    );
  }

  Widget settingDesigne({String title,String imageUrl,Function onTap()}) {
    return GestureDetector(
      onTap: (){
     onTap();
      },
      child: Card(
        elevation: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width,
        
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                   
                    image: DecorationImage(image:AssetImage(imageUrl),
                    fit: BoxFit.fill,
                    
                    ),
                  ),

                ),
              ),
              SizedBox(
width: 10,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 80,
              
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                title,
                style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 16),
              ),
                  ) ,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  child: Icon(Icons.arrow_right_outlined,
                  color: Colors.black,
                  size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
