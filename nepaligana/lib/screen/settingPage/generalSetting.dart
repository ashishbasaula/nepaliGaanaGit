import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disk_space/disk_space.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:nepali_utils/nepali_utils.dart';
import 'package:nepaligana/Login/login.dart';
import 'package:nepaligana/pages/aboutPage.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nepaligana/screen/settingPage/selectTheme.dart';
import 'package:url_launcher/url_launcher.dart';

class generalSetting extends StatefulWidget {
  String loginType;
  generalSetting(this.loginType);
  @override
  _generalSettingState createState() => _generalSettingState(loginType);
}

class _generalSettingState extends State<generalSetting> {
  String loginType;
  _generalSettingState(this.loginType);
  Map user;
  final facebookLogin = FacebookLogin();
  String imageUrl;
  String email;
  String name;
  String languageName = "English";
  String imageResolution = "wifi Only";
  String audioResolution = "Auto";
  bool backgroundEnable = false;
  String backGroundPath = "";
  String shareUrl;
  static var baseStorage;
  void initState() {
    // TODO: implement initState
    super.initState();

    if (loginType == "Facebook") {
      _faceBookUserData();
    } else if (loginType == "Google") {
      _googleUserData();
    } else if (loginType == "Phone") {
      _phone();
    } else if (loginType == "Email") {
      _emailLogin();
    }
    getPreferences();
    fetchShareUrl();
  }

  void getPreferences() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      backgroundEnable = _pref.getBool("backGroundEnable") ?? false;
      backGroundPath = _pref.getString("backGroundUrl");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var dateNepali = NepaliDateFormat.yMMMEd().format(NepaliDateTime.now());
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: backGroundPath != null
              ? Image.asset(
                  backGroundPath,
                  fit: BoxFit.fill,
                )
              : Text(""),
        ),
        Scaffold(
          backgroundColor:
              backgroundEnable == true ? Colors.transparent : Colors.white,
          appBar: AppBar(
            title: Text(
              "General Setting",
              style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        Colors.indigo,
                        Colors.cyan,
                      ])),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                            image: DecorationImage(
                                image: imageUrl != null
                                    ? NetworkImage(imageUrl)
                                    : AssetImage("assets/party.jpg"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Welcome To Nepali Gaana Setting",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(name != null ? name : "",
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 18,
                                        color: Colors.black,
                                      )),
                                ),
                                // email
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(email != null ? email : "",
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 18,
                                        color: Colors.black,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    dateNepali,
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.deepOrange,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // general Setting Start

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Display Setting",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      "App Display Language",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "You Can Change Display Language Here",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: languageName,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Color(0xffC70039).withOpacity(0.5)),
                      elevation: 16,
                      iconSize: 0.0,
                      underline: Container(
                        color: Color(0xffECE5E3),
                      ),
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          languageName = newValue;
                        });
                      },
                      items: <String>['English', 'Nepali']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

// highResolution Image
                Card(
                  child: ListTile(
                    title: Text(
                      "High Resolution Image",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "You Can Change Display High Resolution Image",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: imageResolution,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Color(0xffC70039).withOpacity(0.5)),
                      elevation: 16,
                      iconSize: 0.0,
                      underline: Container(
                        color: Color(0xffECE5E3),
                      ),
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          imageResolution = newValue;
                        });
                      },
                      items: <String>['wifi Only', '3G', '2G']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
// Night Mode
                Card(
                  child: ListTile(
                      title: Text(
                        "Night Mode",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "You Can Swith Mode ",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      trailing: Switch(
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        onChanged: (value) {
                          print(value);
                        },
                        value: false,
                      )),
                ),
                // change app Theme
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => changeTheme()));
                    },
                    title: Text(
                      "Change Setting Theme ",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "You Can Change BackGround of Setting",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),

// downloadSetting
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Download Setting",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                      title: Text(
                        "Free Download Enable",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "Enable You To Download Music For Free",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      trailing: Switch(
                        activeTrackColor: Colors.red,
                        onChanged: (value) {
                          print(value);
                        },
                        value: true,
                      )),
                ),
// audio Download Quality
                Card(
                  child: ListTile(
                    title: Text(
                      "High Audio Quality",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Download High Quality Audio",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: audioResolution,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Color(0xffC70039).withOpacity(0.5)),
                      elevation: 16,
                      iconSize: 0.0,
                      underline: Container(
                        color: Color(0xffECE5E3),
                      ),
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          audioResolution = newValue;
                        });
                      },
                      items: <String>['Auto', 'High', 'Hd', 'Regular']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "You Cannot Change Storage Location");
                    },
                    title: Text(
                      "Download Location",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      baseStorage.toString(),
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Application Setting",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // rate this App
                Card(
                  child: ListTile(
                    onTap: () async {
                      await canLaunch(shareUrl)
                          ? await launch(shareUrl)
                          : throw 'Could not launch $shareUrl';
                    },
                    title: Text(
                      "Rate App",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Love Nepali Ganna Rate Us 5 Star In PlayStore",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                      size: 30,
                    ),
                  ),
                ),
                // share this app To your friends
                Card(
                  child: ListTile(
                    onTap: () {
                      Share.share(shareUrl);
                    },
                    title: Text(
                      "Share App",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Love Nepali Ganna Share Amoung Your Friends",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.share,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
                //about us
                //
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => aboutUs()));
                    },
                    title: Text(
                      "About Us",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "About Developer",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.developer_mode_rounded,
                      color: Colors.pink,
                      size: 30,
                    ),
                  ),
                ),
                //About Mobile Storage
                Card(
                  child: ListTile(
                    onTap: () async {
                      var freeSpace =
                          await DiskSpace.getFreeDiskSpace.toString();
                      Fluttertoast.showToast(
                          msg: "Your Total Space Is:" + freeSpace);
                    },
                    title: Text(
                      "Storage",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "View Your Mobile Storage",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.storage,
                      color: Colors.cyan,
                      size: 30,
                    ),
                  ),
                ),
                // Logout
                Card(
                  child: ListTile(
                    onTap: () async {
                      SharedPreferences _pref =
                          await SharedPreferences.getInstance();
                      _pref.setBool("loginCheck", false).then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      });
                    },
                    title: Text(
                      "LogOut",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Logout Of This App",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void fetchShareUrl() async {
    await FirebaseFirestore.instance
        .collection("DefaultUrl")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          shareUrl = element.data()['Url'];
          print(shareUrl);
        });
      });
    });
  }

  _faceBookUserData() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        var url = Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final graphResponse = await http.get(url);
        final profile = JSON.jsonDecode(graphResponse.body);
        setState(() {
          user = profile;
          imageUrl = user["picture"]["data"]["url"];
          email = user['email'];
          name = user['name'];
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        // TODO: Handle this case.
        break;
      default:
    }
  }

  _googleUserData() {
    FirebaseAuth userData = FirebaseAuth.instance;
    setState(() {
      imageUrl = userData.currentUser.photoURL;
      name = userData.currentUser.displayName;
      email = userData.currentUser.email;
    });
  }

  _emailLogin() {
    FirebaseAuth userData = FirebaseAuth.instance;
    setState(() {
      imageUrl = userData.currentUser.photoURL;
      name = userData.currentUser.displayName;
      email = userData.currentUser.email;
    });
  }

  _phone() {
    FirebaseAuth userData = FirebaseAuth.instance;
    setState(() {
      imageUrl = userData.currentUser.photoURL;
      name = userData.currentUser.phoneNumber;
      email = userData.currentUser.email;
    });
  }
}
