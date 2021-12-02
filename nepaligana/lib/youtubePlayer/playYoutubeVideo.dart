import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class playYoutubeVideo extends StatefulWidget {
  String youtubeUrl;
  playYoutubeVideo(this.youtubeUrl);
  @override
  _playYoutubeVideoState createState() => _playYoutubeVideoState(youtubeUrl);
}

class _playYoutubeVideoState extends State<playYoutubeVideo> {
  String youtubeUrl;
  _playYoutubeVideoState(this.youtubeUrl);

  String playUrl;
  YoutubeMetaData _videoMetaData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playUrl = YoutubePlayer.convertUrlToId(youtubeUrl);
    _videoMetaData = YoutubeMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003366),
        title: Text(
          "Youtube Player",
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: playUrl,
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    player,
                    // this is other widget
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Play On Youtube",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  void _launchURL() async {
    await canLaunch(youtubeUrl)
        ? await launch(youtubeUrl)
        : throw 'Could not launch $youtubeUrl';
  }
}
