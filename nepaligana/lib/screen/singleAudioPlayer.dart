import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';

import 'package:ext_storage/ext_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class singleAudioPlayer extends StatefulWidget {
  String collectionUrl, documentId;
  singleAudioPlayer(this.collectionUrl, this.documentId);
  @override
  _singleAudioPlayerState createState() =>
      _singleAudioPlayerState(collectionUrl, documentId);
}

class _singleAudioPlayerState extends State<singleAudioPlayer>
    with SingleTickerProviderStateMixin {
  String collectionUrl, documentId;
  _singleAudioPlayerState(this.collectionUrl, this.documentId);
  var userid;
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-1756679614544815/3593059879',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  var downloadingPercentage = "0";
  int playerIndex = 0;
  bool checkPlayList = false;
  bool checkDownload = false;
  bool checkLike = false;
  bool checkDislike = false;
  String shareUrl;
  AudioPlayer _player;
  static List<QueryDocumentSnapshot> listdata;
  Timer _timer;
  ReceivePort receivePort = ReceivePort();
  int progress = 0;
  var _playlist;
  var path;
  void _example1() async {
    path = await ExtStorage.getExternalStorageDirectory();
    print(path); // /storage/emulated/0
  }

  int _addedCount = 0;
  @override
  void initState() {
    super.initState();
    _example1();
    getdata();
    _player = AudioPlayer();
    getsharePref();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloadingFile");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallBack);
  }

  void getsharePref() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      userid = _pref.getString("userId");
      print(userid);
    });
  }

  void getdata() async {
    await FirebaseFirestore.instance
        .collection(collectionUrl)
        .doc(documentId)
        .get()
        .then((value) {
      setState(() {
        _playlist = ConcatenatingAudioSource(children: [
          //

          AudioSource.uri(
            Uri.parse(value.data()['musicUrl'] != null
                ? value.data()['musicUrl']
                : "https://firebasestorage.googleapis.com/v0/b/brhssscl.appspot.com/o/adminProfile%2Fgallery%2F2021-03-30%2011%3A03%3A29.121994?alt=media&token=3cd75657-bbdd-4e81-a23c-bdc5f55143c1"),
            tag: AudioMetadata(
              downloadLink: value.data()['musicUrl'] != null
                  ? value.data()['musicUrl']
                  : "https://firebasestorage.googleapis.com/v0/b/brhssscl.appspot.com/o/adminProfile%2Fgallery%2F2021-03-30%2011%3A03%3A29.121994?alt=media&token=3cd75657-bbdd-4e81-a23c-bdc5f55143c1",
              album: value.data()['albumName'] != null
                  ? value.data()['albumName']
                  : "This is Album",
              title: value.data()['title'] != null
                  ? value.data()['title']
                  : "Title",
              artwork: value.data()['imageUrl'] != null
                  ? value.data()['imageUrl']
                  : "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
            ),
          ),
        ]);
      });
    }).then((value) async {
      await _player.setAudioSource(_playlist);
    });
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

  //this is download section
  //

  static downloadCallBack(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloadingFile");
    sendPort.send(progress);
  }

  @override
  void dispose() {
    _player.dispose();
    _timer.cancel();
    super.dispose();
  }

  AudioMetadata metadataOfFile;

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            StreamBuilder<SequenceState>(
              stream: _player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence?.isEmpty ?? true) return SizedBox();
                final metadata = state.currentSource.tag as AudioMetadata;
                Duration time = state.currentSource.duration;
                metadataOfFile = metadata;
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: metadata.artwork != null
                                  ? NetworkImage(metadata.artwork)
                                  : NetworkImage(
                                      "https://image.freepik.com/free-vector/music-background-design_1314-192.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: myBanner),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                      onPressed: () async {
                                        print(userid);
                                        await FirebaseFirestore.instance
                                            .collection("userProfile")
                                            .doc(userid)
                                            .collection("MyPlayList")
                                            .where("musicUrl",
                                                isEqualTo:
                                                    metadata.downloadLink)
                                            .get()
                                            .then((value) {
                                          if (value.docs.isEmpty) {
                                            setState(() {
                                              checkPlayList = false;
                                            });
                                          } else {
                                            setState(() {
                                              checkPlayList = true;
                                            });
                                          }
                                        });

                                        // check for like videos
                                        await FirebaseFirestore.instance
                                            .collection("userProfile")
                                            .doc(userid)
                                            .collection("MyLikeVideo")
                                            .where("musicUrl",
                                                isEqualTo:
                                                    metadata.downloadLink)
                                            .get()
                                            .then((value) {
                                          if (value.docs.isEmpty) {
                                            setState(() {
                                              checkLike = false;
                                            });
                                          } else {
                                            setState(() {
                                              checkLike = true;
                                            });
                                          }
                                        });
                                        //check download video
                                        await FirebaseFirestore.instance
                                            .collection("userProfile")
                                            .doc(userid)
                                            .collection("MyDownloadVideo")
                                            .where("musicUrl",
                                                isEqualTo:
                                                    metadata.downloadLink)
                                            .get()
                                            .then((value) {
                                          if (value.docs.isEmpty) {
                                            setState(() {
                                              checkDownload = false;
                                            });
                                          } else {
                                            setState(() {
                                              checkDownload = true;
                                            });
                                          }
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 50),
                                                padding: EdgeInsets.zero,
                                                backgroundColor: Colors.black,
                                                // margin: EdgeInsets.all(1),
                                                content: Container(
                                                  height: 400,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      //color: Colors.black,
                                                      ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .hideCurrentSnackBar(
                                                                      reason: SnackBarClosedReason
                                                                          .dismiss);
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        Card(
                                                          elevation: 5,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Container(
                                                            height: 150,
                                                            width: 150,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    metadata
                                                                        .artwork),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          metadata.title,
                                                          style: GoogleFonts
                                                              .aBeeZee(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        Text(
                                                          metadata.album,
                                                          style: GoogleFonts
                                                              .aBeeZee(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          "11M+ Play",
                                                          style: GoogleFonts
                                                              .aBeeZee(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                onTap: () {
                                                                  Share.share(
                                                                      shareUrl);
                                                                },
                                                                leading: Icon(
                                                                  Icons.share,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                title: Text(
                                                                  "Share",
                                                                  style: GoogleFonts
                                                                      .aBeeZee(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                              // like button
                                                              //
                                                              //
                                                              //
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  if (checkLike ==
                                                                      false) {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "userProfile")
                                                                        .doc(
                                                                            userid)
                                                                        .collection(
                                                                            "MyLikeVideo")
                                                                        .add({
                                                                      "musicUrl":
                                                                          metadata
                                                                              .downloadLink,
                                                                      "albumName":
                                                                          metadata
                                                                              .album,
                                                                      "title":
                                                                          metadata
                                                                              .title,
                                                                      "imageUrl":
                                                                          metadata
                                                                              .artwork,
                                                                    }).then((value) {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Thanks For Your Like");
                                                                    });
                                                                  } else if (checkLike ==
                                                                      true) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "You Have Already Like This Music");
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                  Icons
                                                                      .thumb_up,
                                                                  color: checkLike ==
                                                                          true
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                title: Text(
                                                                  "Like",
                                                                  style: GoogleFonts
                                                                      .aBeeZee(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),

                                                              // download setting
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  if (checkDownload ==
                                                                      false) {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "userProfile")
                                                                        .doc(
                                                                            userid)
                                                                        .collection(
                                                                            "MyDownloadVideo")
                                                                        .add({
                                                                      "musicUrl":
                                                                          metadata
                                                                              .downloadLink,
                                                                      "albumName":
                                                                          metadata
                                                                              .album,
                                                                      "title":
                                                                          metadata
                                                                              .title,
                                                                      "imageUrl":
                                                                          metadata
                                                                              .artwork,
                                                                    }).then((value) async {
                                                                      final status = await Permission
                                                                          .storage
                                                                          .request();
                                                                      if (status
                                                                          .isGranted) {
                                                                        final id = await FlutterDownloader.enqueue(
                                                                            url: metadata
                                                                                .downloadLink,
                                                                            savedDir:
                                                                                path,
                                                                            fileName:
                                                                                metadata.title + ".mp3");
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Your Music is downloading");
                                                                      } else {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "No Premission Granted");
                                                                      }
                                                                    });
                                                                  } else if (checkDownload ==
                                                                      true) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "You Have Already Download This Music");
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                  checkDownload ==
                                                                          true
                                                                      ? FontAwesomeIcons
                                                                          .fileDownload
                                                                      : FontAwesomeIcons
                                                                          .download,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                title: Text(
                                                                  "Download",
                                                                  style: GoogleFonts
                                                                      .aBeeZee(
                                                                    color: checkDownload ==
                                                                            true
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  print(userid);
                                                                  if (checkPlayList ==
                                                                      false) {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "userProfile")
                                                                        .doc(
                                                                            userid)
                                                                        .collection(
                                                                            "MyPlayList")
                                                                        .add({
                                                                      "musicUrl":
                                                                          metadata
                                                                              .downloadLink,
                                                                      "albumName":
                                                                          metadata
                                                                              .album,
                                                                      "title":
                                                                          metadata
                                                                              .title,
                                                                      "imageUrl":
                                                                          metadata
                                                                              .artwork,
                                                                    }).then((value) {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Successfully Added to PlayList");
                                                                    });
                                                                  } else if (checkPlayList ==
                                                                      true) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Music Already Exist in playList");
                                                                  }
                                                                },
                                                                leading: Icon(
                                                                  Icons
                                                                      .playlist_add,
                                                                  color: checkPlayList ==
                                                                          true
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                title: Text(
                                                                  "Add To PlayList",
                                                                  style: GoogleFonts
                                                                      .aBeeZee(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )));
                                      },
                                      child: Icon(
                                        Icons.info_rounded,
                                        color: Colors.red,
                                        size: 50,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              metadata.title,
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                color: Colors.white,
                                iconSize: 28,
                                icon: Icon(Icons.file_download),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("userProfile")
                                      .doc(userid)
                                      .collection("MyDownloadVideo")
                                      .where("musicUrl",
                                          isEqualTo: metadata.downloadLink)
                                      .get()
                                      .then((value) async {
                                    if (value.docs.isEmpty) {
                                      await FirebaseFirestore.instance
                                          .collection("userProfile")
                                          .doc(userid)
                                          .collection("MyDownloadVideo")
                                          .add({
                                        "musicUrl": metadata.downloadLink,
                                        "albumName": metadata.album,
                                        "title": metadata.title,
                                        "imageUrl": metadata.artwork,
                                      }).then((value) async {
                                        final status =
                                            await Permission.storage.request();
                                        if (status.isGranted) {
                                          final id =
                                              await FlutterDownloader.enqueue(
                                                  url: metadata.downloadLink,
                                                  savedDir: path,
                                                  showNotification: true,
                                                  fileName:
                                                      metadata.title + ".mp3");
                                          Fluttertoast.showToast(
                                              msg: "Your Music is downloading");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "No Premission Granted");
                                        }
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You Have Already Download This Music");
                                    }
                                  });
                                }),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                color: Colors.red,
                                iconSize: 28,
                                icon: Icon(Icons.thumb_up),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("userProfile")
                                      .doc(userid)
                                      .collection("MyLikeVideo")
                                      .where("musicUrl",
                                          isEqualTo: metadata.downloadLink)
                                      .get()
                                      .then((value) async {
                                    if (value.docs.isEmpty) {
                                      await FirebaseFirestore.instance
                                          .collection("userProfile")
                                          .doc(userid)
                                          .collection("MyLikeVideo")
                                          .add({
                                        "musicUrl": metadata.downloadLink,
                                        "albumName": metadata.album,
                                        "title": metadata.title,
                                        "imageUrl": metadata.artwork,
                                      }).then((value) {
                                        Fluttertoast.showToast(
                                            msg: "Thanks For Your Like");
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You Have Already Like This Music");
                                    }
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      downloadingPercentage,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ],
                );
              },
            ),

            Row(
              children: [
                //
                //this is repet mode
                //
                Expanded(
                  child: StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.orange),
                        Icon(Icons.repeat_one, color: Colors.orange),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                              (cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                ),

                //
                //
                //
                //this is control Button
                ControlButtons(_player),

                //this is siffer mode
                //
                //
                //
                //
                Expanded(
                  child: StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: Colors.orange)
                            : Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await _player.shuffle();
                          }
                          await _player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            //this is duration control
            //
            StreamBuilder<Duration>(
              stream: _player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<PositionData>(
                  stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                      _player.positionStream,
                      _player.bufferedPositionStream,
                      (position, bufferedPosition) =>
                          PositionData(position, bufferedPosition)),
                  builder: (context, snapshot) {
                    final positionData = snapshot.data ??
                        PositionData(Duration.zero, Duration.zero);
                    var position = positionData.position;
                    if (position > duration) {
                      position = duration;
                    }
                    var bufferedPosition = positionData.bufferedPosition;
                    if (bufferedPosition > duration) {
                      bufferedPosition = duration;
                    }
                    return SeekBar(
                      duration: duration,
                      position: position,
                      bufferedPosition: bufferedPosition,
                      onChangeEnd: (newPosition) {
                        _player.seek(newPosition);
                      },
                    );
                  },
                );
              },
            ),

// this is play List section

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Next in Queue",
                style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 240.0,
              color: Colors.black,
              child: StreamBuilder<SequenceState>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  final metadata = state.currentSource.tag as AudioMetadata;
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      _playlist.move(oldIndex, newIndex);
                    },
                    children: [
                      for (var i = 0; i < sequence.length; i++)
                        Dismissible(
                          key: ValueKey(sequence[i]),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (dismissDirection) {
                            _playlist.removeAt(i);
                          },
                          child: Material(
                            color: i == state.currentIndex
                                ? Colors.teal.shade800
                                : null,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.black,
                              child: ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://image.freepik.com/free-vector/music-background-design_1314-192.jpg"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  sequence[i].tag.title as String,
                                  style: GoogleFonts.aBeeZee(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    playerIndex = i;
                                  });
                                  _player.seek(Duration.zero, index: i);
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*  IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            _showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),*/
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous),
            color: Colors.red,
            iconSize: 40,
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                color: Color(0xffEC7063),
                onPressed: () async {
                  player.play();
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                color: Color(0xffD0D3D4),
                iconSize: 55.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                color: Colors.white,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_next),
              color: Colors.red,
              iconSize: 40,
              onPressed: () {
                if (player.hasNext) {
                  player.seekToNext();
                  print("this was called");
                } else {
                  null;
                }
              }),
        ),
        /*  StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
        */
      ],
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    @required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Color(0xff1F618D),
            inactiveTrackColor: Colors.red.shade200,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: widget.bufferedPosition.inMilliseconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            activeColor: Colors.red,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch("$_remaining")
                    ?.group(1) ??
                '$_remaining',
            style: GoogleFonts.aBeeZee(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

void _showSliderDialog({
  @required BuildContext context,
  @required String title,
  @required int divisions,
  @required double min,
  @required double max,
  String valueSuffix = '',
  @required Stream<double> stream,
  @required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;
  final String downloadLink;

  AudioMetadata(
      {@required this.album,
      @required this.title,
      @required this.artwork,
      @required this.downloadLink});
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    @required Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    @required bool isDiscrete,
    @required TextPainter labelPainter,
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required TextDirection textDirection,
    @required double value,
    @required double textScaleFactor,
    @required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}
