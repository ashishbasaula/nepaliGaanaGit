import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class changeTheme extends StatefulWidget {
  @override
  _changeThemeState createState() => _changeThemeState();
}

class _changeThemeState extends State<changeTheme> {
  @override
  Widget build(BuildContext context) {
       SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "App Theme",
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        
        child: Column(
          children: [
            Text(
                  "Click The Tab To Apply Theme and Restart to apply Change",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
image: AssetImage("assets/backGround.jpg"),
fit: BoxFit.fill,
                  ),
                ),
                child: ListTile(
                  onTap: () async {
                    print("theme Selected");
                    SharedPreferences _pref = await SharedPreferences.getInstance();
                    _pref.setString("backGroundUrl", "assets/backGround.jpg");
                    _pref.setBool("backGroundEnable", true);
                     Fluttertoast.showToast(msg: "Theme Apply Restart App");
                  },
                  title: Text(
                    "white Flower",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(Icons.done,
                  color:Colors.black,
                  size:30,
                  ),
                ),
              ),
            ),
//Default Theme Data 
 Padding(
   padding: const EdgeInsets.all(8.0),
   child: Container(
               color: Colors.white30,
                child: ListTile(
                  onTap: () async {
                    print("theme Selected");
                    SharedPreferences _pref = await SharedPreferences.getInstance();
                  //  _pref.setString("backGroundUrl", "assets/backGround.jpg");
                    _pref.setBool("backGroundEnable", false);
                    Fluttertoast.showToast(msg: "Theme Apply Restart App");
                  },
                  title: Text(
                    "Default",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(Icons.done,
                  color:Colors.black,
                  size:30,
                  ),
                ),
              ),
 ),
           // backGround2
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
image: AssetImage("assets/background2.jpg"),
fit: BoxFit.fill,
                  ),
                ),
                child: ListTile(
                  onTap: () async {
                    print("theme Selected");
                    SharedPreferences _pref = await SharedPreferences.getInstance();
                    _pref.setString("backGroundUrl", "assets/background2.jpg");
                    _pref.setBool("backGroundEnable", true);
                     Fluttertoast.showToast(msg: "Theme Apply Restart App");
                  },
                  title: Text(
                    "Morning Flower",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(Icons.done,
                  color:Colors.black,
                  size:30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
