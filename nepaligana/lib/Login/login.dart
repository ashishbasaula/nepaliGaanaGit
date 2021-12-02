import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nepaligana/Dashboard/dashBoard.dart';
import 'package:nepaligana/Login/phoneAuth.dart';
import 'package:nepaligana/Login/emailLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FacebookLogin _facebookLogin = FacebookLogin();
  FirebaseAuth auth = FirebaseAuth.instance;
  Map user;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "You Cannot Skip ");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashBoard("Email")));
            },
            child: Text(
              "SKIP",
              style: GoogleFonts.aBeeZee(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 190,
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage("assets/nepaliGaana.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Hello Nepali Gaana User,",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "You Previousely Logged In to Gaana with",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Google",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).size.height - kToolbarHeight) * 0.19,
            ),
            GestureDetector(
              onTap: () async {
                signInWithGoogle();
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    "Continue with Google ",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).size.height - kToolbarHeight) * 0.04,
            ),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    height: 10,
                    margin: const EdgeInsets.only(left: 30.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
              Text("Or Continue With"),
              Expanded(
                child: new Container(
                    height: 10,
                    margin: const EdgeInsets.only(left: 10.0, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
            ]),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0),
                  socialMediaLogin(
                      Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                        size: 50,
                      ),
                      "Facebook", ontap: () {
                    _handelLogin();
                    return;
                  }),
                  socialMediaLogin(
                      Icon(
                        FontAwesomeIcons.mobile,
                        color: Colors.red,
                        size: 50,
                      ),
                      "Phone", ontap: () {
                    // signInWithGoogle();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneAuthincation()));
                    return;
                  }),
                  socialMediaLogin(
                      Icon(
                        Icons.email,
                        color: Colors.red,
                        size: 50,
                      ),
                      "Email", ontap: () {
                    print("This is Email");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EmailLogin()));
                    return;
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget socialMediaLogin(Icon icon, String title, {Function ontap()}) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
        child: Column(
          children: [
            IconButton(
                icon: icon,
                onPressed: () {
                  ontap();
                }),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                title,
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//handle firebase login
  Future _handelLogin() async {
    FacebookLoginResult loginResut = await _facebookLogin.logIn(['email']);
    switch (loginResut.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = loginResut.accessToken;
        await _loginWithFaceBook(loginResut);
        Map user;
        final token = loginResut.accessToken.token;
        var url = Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final graphResponse = await http.get(url);
        final profile = JSON.jsonDecode(graphResponse.body);
        setState(() {
          user = profile;
        });
        FirebaseFirestore.instance
            .collection("userProfile")
            .doc(profile['id'])
            .set({
          "UserName": user['name'],
          "UserId": profile['id'],
          "UserEmail": user['email'],
          "UserPhoto": user["picture"]["data"]["url"],
        }).then((value) async {
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setBool("loginCheck", true);
          _pref.setString("userId", profile['id']);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashBoard("Facebook")));
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        Fluttertoast.showToast(msg: "Login Cancelled By User");
        break;
      case FacebookLoginStatus.error:
        Fluttertoast.showToast(msg: "Some things went Wrong");
        break;
    }
  }

  Future _loginWithFaceBook(FacebookLoginResult result) async {
    FacebookAccessToken _accessToken = result.accessToken;
    AuthCredential _credential =
        FacebookAuthProvider.credential(_accessToken.token);
    var authSignInCresential = await auth.signInWithCredential(_credential);
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignIn _signIn = GoogleSignIn();

    try {
      final GoogleSignInAccount userAccount = await _signIn.signIn();

      if (userAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await userAccount.authentication;
        print(googleAuth);

        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        print(credential);
        User user = (await auth.signInWithCredential(credential)).user;
        Fluttertoast.showToast(msg: user.email);
        FirebaseFirestore.instance.collection("userProfile").doc(user.uid).set({
          "UserName": user.displayName,
          "UserId": user.uid,
          "UserEmail": user.email,
          "UserPhoto": user.photoURL,
        }).then((value) async {
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setBool("loginCheck", true);
          _pref.setString("userId", user.uid);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashBoard("Google")));
        });
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_USER_DISABLED':
          Fluttertoast.showToast(msg: "Google Sign-In error: User disabled");
          break;
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          Fluttertoast.showToast(
              msg:
                  "Google Sign-In error: Account already exists with a different credential.");
          break;
        case 'ERROR_INVALID_CREDENTIAL':
          print('Google Sign-In error: Invalid credential.');
          Fluttertoast.showToast(
              msg: "Google Sign-In error: Invalid credential.");

          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          print('Google Sign-In error: Operation not allowed.');
          Fluttertoast.showToast(
              msg: "Google Sign-In error: Operation not allowed.");
          break;
        default:
          print('Google Sign-In error');
          Fluttertoast.showToast(msg: "Google Sign-In error");
          break;
      }
      print(e);
    } catch (e) {
      print(e.message);
    }
  }
}
