import 'package:audio_service/audio_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepaligana/Dashboard/dashBoard.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  bool connectivityData = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    connectivityData = true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    connectivityData = true;
  } else {
    connectivityData = false;
  }
  runApp(
    MaterialApp(
      home: connectivityData == true ? checkAndReturn() : noInternet(),
      debugShowCheckedModeBanner: false,
      title: "Nepali Gaana",
    ),
  );
}

class checkAndReturn extends StatefulWidget {
  @override
  _checkAndReturnState createState() => _checkAndReturnState();
}

class _checkAndReturnState extends State<checkAndReturn> {
  bool loginStatus = false;
  void getShareData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      loginStatus = _pref.getBool("loginCheck") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    getShareData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      home: loginStatus == true ? DashBoard("Google") : Login(),
      debugShowCheckedModeBanner: false,
      title: "Nepali Gaana",
    );
  }
}

class noInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.cyan.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("assets/nepaliGaana.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Icon(
              Icons.construction_outlined,
              color: Colors.red,
              size: 50,
            ),
            Text(
              "No Internet Connection! Please Connect To Your Internet And Press Click me ",
              style: GoogleFonts.aBeeZee(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.mobile) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => checkAndReturn()));
                } else if (connectivityResult == ConnectivityResult.wifi) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => checkAndReturn()));
                } else {
                  Fluttertoast.showToast(
                      msg: "You Are Still Not Connected To Internet");
                }
              },
              child: Text(
                "Click Me",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
