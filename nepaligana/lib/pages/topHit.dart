import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class topHit extends StatefulWidget {
  @override
  _topHitState createState() => _topHitState();
}

class _topHitState extends State<topHit> {
  @override
  Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
    return Scaffold(
      body: Center(
        child: Text("this is Top Hit Page",
        style: GoogleFonts.aBeeZee(
          color: Colors.blue,
          fontSize: 20,
        ),
        ),
      ),
    );
  }
}