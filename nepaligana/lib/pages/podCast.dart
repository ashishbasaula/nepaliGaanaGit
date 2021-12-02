import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class podcast extends StatefulWidget {
  @override
  _podcastState createState() => _podcastState();
}

class _podcastState extends State<podcast> {
  @override
  Widget build(BuildContext context) {
       SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
    
      body: Center(
       child: Container(
         height: 50,
         width: MediaQuery.of(context).size.width*0.9,
         child: LiquidLinearProgressIndicator(
  value: 0.5, // Defaults to 0.5.
  valueColor: AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
  backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
  borderColor: Colors.cyan,
  borderWidth: 5.0,
  borderRadius: 12.0,
  direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
  center: Text("Loading..."),
),
       ),
      ),
    );
  }
}