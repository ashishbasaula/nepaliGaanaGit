import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:nepaligana/Login/login.dart';
import 'package:nepaligana/screen/Home.dart';
import 'package:nepaligana/screen/settingPage/userSetting.dart';
import 'package:nepaligana/youtubePlayer/playYoutubeVideo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nepaligana/screen/videoControl/videoPlayer.dart';
import 'package:nepaligana/screen/settingPage/generalSetting.dart';
import 'package:nepaligana/pages/podCast.dart';
import 'package:nepaligana/pages/allSearchPage.dart';
import '../screen/videoControl/videoPlayList.dart';

class DashBoard extends StatefulWidget {
  final titles = ['Home', 'PodCast', 'Videos', 'Profile'];
  final colors = [Colors.red, Colors.purple, Colors.teal, Colors.cyan];
  final icons = [
    CupertinoIcons.home,
    FontAwesomeIcons.podcast,
    CupertinoIcons.video_camera_solid,
    CupertinoIcons.profile_circled
  ];
  String loginType;
  DashBoard(this.loginType);
  @override
  _DashBoardState createState() => _DashBoardState(loginType);
}

class _DashBoardState extends State<DashBoard> {
  String loginType;
  _DashBoardState(this.loginType);
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  Map user;
  final facebookLogin = FacebookLogin();
  String imageUrl;
  String email;
  String name;

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    if (loginType == "Facebook") {
      _faceBookUserData();
    } else if (loginType == "Google") {
      _googleUserData();
    } else {
      print(loginType);
    }

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);

    super.initState();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var media = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_required_param
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                actions: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: media.size.height * 0.09,
                            width: media.size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color(0xfff08080),
                                Color(0xffffb6c1),
                                Color(0xffffc0cb),
                              ]),
                            ),
                            child: Center(
                                child: Text(
                              "NO",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff191970),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            SystemNavigator.pop();
                          },
                          child: Container(
                            height: media.size.height * 0.09,
                            width: media.size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color(0xfff08080),
                                Color(0xffffb6c1),
                                Color(0xffffc0cb),
                              ]),
                            ),
                            child: Center(
                                child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff191970),
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Do You Want to Exit Gaana Nepal ?",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff008b8b),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Tapping Yes will Exit App",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfff08080),
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Icon(
              Icons.search,
              color: Colors.black,
              size: 50,
            ),
            title: Container(
              height: kToolbarHeight,
              width: 200,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchAll()));
                  },
                  child: Text(
                    " Tap To Search",
                    style:
                        GoogleFonts.aBeeZee(color: Colors.black, fontSize: 18),
                  )),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  // SharedPreferences _pref = await SharedPreferences.getInstance();
                  // _pref.setBool("loginCheck", false).then((value) {
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: (context) => Login()));
                  // });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => generalSetting(loginType)));
                },
                child: Container(
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: imageUrl != null
                            ? NetworkImage(imageUrl)
                            : AssetImage("assets/user.png"),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
            ],
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              checkUserDragging(scrollNotification);
            },
            child: PageView(
              controller: _pageController,
              children: [
                HomePage(),
                podcast(),
                videoList(),
                myLibrary(),
              ],
              onPageChanged: (page) {},
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: BubbledNavigationBar(
              controller: _menuPositionController,
              initialIndex: 0,
              itemMargin: EdgeInsets.symmetric(horizontal: 5),
              backgroundColor: Colors.white,
              defaultBubbleColor: Colors.blue,
              onTap: (index) {
                _pageController.animateToPage(index,
                    curve: Curves.easeInOutQuad,
                    duration: Duration(milliseconds: 500));
              },
              items: widget.titles.map((title) {
                var index = widget.titles.indexOf(title);
                var color = widget.colors[index];
                return BubbledNavigationBarItem(
                  icon: getIcon(index, color),
                  activeIcon: getIcon(index, Colors.white),
                  bubbleColor: color,
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          )),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(widget.icons[index], size: 30, color: color),
    );
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

  _logout() {
    facebookLogin.logOut();
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }
}
