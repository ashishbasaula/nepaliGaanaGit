import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nepaligana/screen/audioPlayer.dart';

import 'package:nepaligana/navigatorwindow/artistProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'singleAudioPlayer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userid;
  int maxFailedLoadAttempts = 3;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    // TODO: implement initState

    _createInterstitialAd();
    super.initState();
    getsharePref();
  }

  void getsharePref() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      userid = _pref.getString("userId");
      print(userid);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  audioPlayerPage("AllMusic")));
                    },
                    child: Text(
                      "All",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => audioPlayerPage("TopHit")));
                    },
                    child: Text(
                      "Top Hits",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  audioPlayerPage("RecentlyAdded")));
                    },
                    child: Text(
                      "Recently Added",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  audioPlayerPage("FestivalSongs")));
                    },
                    child: Text(
                      "Festival Song",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  audioPlayerPage("OldSongs")));
                    },
                    child: Text(
                      "Old Songs ",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  audioPlayerPage("NewSong")));
                    },
                    child: Text(
                      "New Songs ",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  audioPlayerPage("BhaktiSong")));
                    },
                    child: Text(
                      "Bhakti Song",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recently Liked",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          var androidInfo =
                              await DeviceInfoPlugin().androidInfo;
                          var release = androidInfo.version.release;
                          var sdkInt = androidInfo.version.sdkInt;
                          var manufacturer = androidInfo.manufacturer;
                          var model = androidInfo.model;
                          print(
                              'Android $release (SDK $sdkInt), $manufacturer $model');
                          print(release.split(".")[0]);
                          // Android 9 (SDK 28), Xiaomi Redmi Note 7
                        }
                      },
                      child: Text(
                        "See All",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 180,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("userProfile")
                      .doc(userid)
                      .collection("MyLikeVideo")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.docs.map((document) {
                          return GestureDetector(
                            onTap: () {
                              _showInterstitialAd();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => singleAudioPlayer(
                                          "userProfile/" +
                                              userid +
                                              "/MyLikeVideo",
                                          document.id)));
                            },
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: document['imageUrl'] != null
                                            ? NetworkImage(document['imageUrl'])
                                            : AssetImage(
                                                "assets/rabbaMeher.jpg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      document['title'] != null
                                          ? document['title']
                                          : "Title",
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.aBeeZee(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }),
            ),
// this is top chart Page
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Top Chart",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print("this is see all Page");
                      },
                      child: Text(
                        "See All",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 180, child: topChart()),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nepali Other ",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print("this is see all Page");
                      },
                      child: Text(
                        "See All",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 180, child: nepaliOtherProduct()),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mood And Collection",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print("this is see all Page");
                      },
                      child: Text(
                        "See All",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 180, child: moodAndCollection()),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pick Artist",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print("this is see all Page");
                      },
                      child: Text(
                        "See All",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 300, child: artistProfile()),
          ],
        ),
      ),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }
}

class topChart extends StatelessWidget {
  int maxFailedLoadAttempts = 3;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        topChartFrame(
            chartTitle: "Nepali Top 50",
            cardColor: Colors.red,
            imageUrl: "assets/nepaliTop10.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("NepaliTop50")));
            }),
        topChartFrame(
            chartTitle: "Top 50 Festival Song",
            cardColor: Colors.blue,
            imageUrl: "assets/festival.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("top50Festival")));
            }),
        topChartFrame(
            chartTitle: "Top 10 Bhajan",
            cardColor: Colors.green,
            imageUrl: "assets/bhajan.png",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("top10Bhajan")));
            }),
        topChartFrame(
            chartTitle: "Top 50 Movie Song",
            cardColor: Colors.pink,
            imageUrl: "assets/movie.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("top50MovieSong")));
            }),
        topChartFrame(
            chartTitle: "Top 10 Romance Song",
            cardColor: Colors.cyan,
            imageUrl: "assets/romance.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("RomenticSong")));
            }),
        topChartFrame(
            chartTitle: "Top 10 Pop Song",
            cardColor: Colors.teal,
            imageUrl: "assets/popSong.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("PopSong")));
            }),
        topChartFrame(
            chartTitle: "Top 10 Dance Song",
            cardColor: Colors.teal,
            imageUrl: "assets/dance.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("DanceSong")));
            }),
      ],
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  Widget topChartFrame(
      {String chartTitle,
      Color cardColor,
      String imageUrl,
      Function onPress()}) {
    return GestureDetector(
      onTap: () {
        _createInterstitialAd();
        loadAds();
        onPress();

        return;
      },
      child: Column(
        children: [
          Container(
            height: 140,
            width: 140,
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 02,
                  ),
                  Text(
                    chartTitle,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // this is button text
          Text(
            chartTitle,
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // this is for loading the ads
  Future<void> loadAds() {
    Future.delayed(Duration(microseconds: 10), () {
      _showInterstitialAd();
    });
  }
}

class nepaliOtherProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        nepaliOtherPorduct(
            otherTitle: "श्रीमद भागवत कथा ",
            cardColor: Colors.amber,
            imageUrl: "assets/bhabgatGeeta.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("bhabgatGeeta")));
            }),
        nepaliOtherPorduct(
            otherTitle: "नेपाली कविता ",
            cardColor: Colors.purple,
            imageUrl: "assets/kabita.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("nepaliKabita")));
            }),
        nepaliOtherPorduct(
            otherTitle: "नेपाली गजल ",
            cardColor: Colors.deepOrange,
            imageUrl: "assets/gajal.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("nepaliGajal")));
            }),
      ],
    );
  }

  Widget nepaliOtherPorduct(
      {String otherTitle,
      Color cardColor,
      String imageUrl,
      Function onPress()}) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Column(
        children: [
          Container(
            height: 140,
            width: 140,
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 02,
                  ),
                  Text(
                    otherTitle,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // this is button text
          Text(
            otherTitle,
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// mood and collection
//
class moodAndCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        moodFrame(
            moodTitle: "Romance Song",
            cardColor: Colors.amber,
            imageUrl: "assets/romance.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("RomenticSong")));
            }),
        moodFrame(
            moodTitle: "Pop Song",
            cardColor: Colors.indigo,
            imageUrl: "assets/popSong.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("PopSong")));
            }),
        moodFrame(
            moodTitle: "Old Song",
            cardColor: Colors.grey,
            imageUrl: "assets/oldSong.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("OldSongs")));
            }),
        moodFrame(
            moodTitle: "Party Song",
            cardColor: Colors.brown,
            imageUrl: "assets/party.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("PartySong")));
            }),
        moodFrame(
            moodTitle: "Sad Song",
            cardColor: Colors.red,
            imageUrl: "assets/sad.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("sadSong")));
            }),
        moodFrame(
            moodTitle: "Teej Song",
            cardColor: Colors.deepOrange,
            imageUrl: "assets/teej.jpg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("teejsong")));
            }),
        moodFrame(
            moodTitle: "Dashain/Tihar",
            cardColor: Colors.teal.shade600,
            imageUrl: "assets/dashintihar.jpeg",
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => audioPlayerPage("FestivalSongs")));
            }),
      ],
    );
  }

  Widget moodFrame(
      {String moodTitle,
      Color cardColor,
      String imageUrl,
      Function onPress()}) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Column(
        children: [
          Container(
            height: 140,
            width: 140,
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 02,
                  ),
                  Text(
                    moodTitle,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // this is button text
          Text(
            moodTitle,
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
