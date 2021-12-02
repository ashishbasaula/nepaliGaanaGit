import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class localMusicPlayer extends StatefulWidget {
  String audioUrl;
  localMusicPlayer(this.audioUrl);

  @override
  _localMusicPlayerState createState() => _localMusicPlayerState(audioUrl);
}

class _localMusicPlayerState extends State<localMusicPlayer> {
 static  Duration totalDuration;
 Duration position;
    String audioUrl;
  _localMusicPlayerState(this.audioUrl);
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);


  void playAudio() async{
  await  audioPlayer.play(audioUrl,isLocal: true);
 
  }

  void pause() {
  audioPlayer.pause();
  print(audioUrl);
  }

  void stopAudio() {
    audioPlayer.stop();
  }
void initAudio(){
 audioPlayer.onDurationChanged.listen((Duration d) {
    print('Max duration: $d');
    setState(() {
    totalDuration=d;
    print(totalDuration);
    });
  });

   audioPlayer.onAudioPositionChanged.listen((Duration  updatePosition)  {
  setState(() {
    position=updatePosition;
    print(position);
  });
  });
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 initAudio();
  }

  @override
  Widget build(BuildContext context) {
       SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        elevation: 0,
        title: Text("LocalPlayer",
        style: GoogleFonts.aBeeZee(
          color: Colors.black,
          fontSize: 16,

        ),
        ),
        leading: BackButton(color: Colors.black,),
      ),
      body: SingleChildScrollView(
              child: Column(
          children: [
            Center(
child: Card(
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(30))
  ),
 child: Container(
   height: MediaQuery.of(context).size.height*0.5,
   
   width: MediaQuery.of(context).size.width*0.8,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(30)),
   image: DecorationImage(
image: AssetImage("assets/dance.jpg"),
fit: BoxFit.fill,
   ) ,
  ),
 ),
),
            ),
            Center(
child: Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  ),
  elevation: 10,
  child: Container(
    height: MediaQuery.of(context).size.height*0.14,
    width: MediaQuery.of(context).size.width*0.8,

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
          color: Colors.pink,
    ),
    child: Center(
      child: Row(
       children: [
        Expanded(
child: IconButton(icon: Icon(Icons.pause,
color: Colors.black,
size: 50,
), onPressed: (){
    pause();
}),
        ) ,
          Expanded(
child: IconButton(icon: Icon(Icons.play_circle_fill_sharp,
color: Colors.black,
size: 50,
), onPressed: (){
   playAudio();
}),
        ) ,
          Expanded(
child: IconButton(icon: Icon(Icons.stop,
color: Colors.black,
size: 50,
), onPressed: (){
    stopAudio();
}),
        ) ,
       ], 
      ),
    ),
  ),
),
            ),
           Center(
             child: Row(
               children: [
                 SizedBox(
width: MediaQuery.of(context).size.width*0.4,
                 ),
                 Text(totalDuration.toString().split(".").first+"/"+position.toString().split(".").first),
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}
