import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class aboutUs extends StatefulWidget {
  @override
  _aboutUsState createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> {
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'glues632@gmail.com',
      queryParameters: {'subject': 'FeedBack And Report To App'});
  @override
  Widget build(BuildContext context) {
       SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "About Us",
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Colors.cyan,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "About Gaana Nepal",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage("assets/nepaliGaana.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        "App Info",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Gaana Nepal Was developed in 2021 .It Was developed To provide User Music in easy way .  All The Music in this app was composed by Nepali Singer . The Main Motive of this app is to provide user Easy access to music . By Using this app User can Easily Download Music in One click . User Can Easily Create Their Own Play List And Play them Any Time . ",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 2,
                        endIndent: 20,
                        indent: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Developer Info",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.device_hub_outlined,
                          color: Colors.amber,
                          size: 40,
                        ),
                        title: Text(
                          "Name",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "Ashish Basaula",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          await canLaunch(_emailLaunchUri.toString())
                              ? await launch(_emailLaunchUri.toString())
                              : throw 'Could not launch $_emailLaunchUri';
                        },
                        leading: Icon(
                          Icons.email,
                          color: Colors.red.shade600,
                          size: 40,
                        ),
                        title: Text(
                          "Email",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "glues632@gmail.com",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 2,
                        endIndent: 20,
                        indent: 20,
                      ),
                      Text(
                        "Our Other App",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                                                      child: GestureDetector(
                              onTap: () async {
                                await canLaunch(
                                        "https://play.google.com/store/apps/details?id=com.hero.entrance")
                                    ? await launch(
                                        "https://play.google.com/store/apps/details?id=com.hero.entrance")
                                    : throw 'Could not launch ';
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.pink,
                                    ),
                                  ),
                                  Text(
                                    "Entrance Prepration Np",
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                           Expanded(
                                                        child: GestureDetector(
                              onTap: () async {
                                await canLaunch(
                                        "https://play.google.com/store/apps/details?id=com.phoneDiary.np")
                                    ? await launch(
                                        "https://play.google.com/store/apps/details?id=com.phoneDiary.np")
                                    : throw 'Could not launch ';
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.pink,
                                      image: DecorationImage(
image: AssetImage("assets/phoneDiaryApp.jpg"),
fit: BoxFit.fill
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Nepal Phone Number Diary",
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontSize: 8,
                                    ),
                                    overflow: TextOverflow.ellipsis
                                  ),
                                ],
                              ),
                          ),
                           ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
