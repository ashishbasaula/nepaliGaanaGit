import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


class videoPlayer extends StatefulWidget {
  String videoUrl;
  videoPlayer(this.videoUrl);
  @override
  _videoPlayerState createState() => _videoPlayerState(videoUrl);
}

class _videoPlayerState extends State<videoPlayer> {
  VideoPlayerController _controller;
  String videoUrl;
  _videoPlayerState(this.videoUrl);
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl!=null?videoUrl:
        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return WillPopScope(
      onWillPop: (){
        _controller.pause();
      },
          child: Scaffold(
          body: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
    );
  }
}