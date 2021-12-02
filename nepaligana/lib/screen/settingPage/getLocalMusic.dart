import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'playLocalMusic.dart';
//import package files



//apply this class on home: attribute at MaterialApp()
class MyAudioList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyAudioList(); //create state 
  }
}

class _MyAudioList extends State<MyAudioList>{
  var files;
 
  void getFiles() async { //asyn function to get list of files
      List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
      var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
      var fm = FileManager(root: Directory(root)); //
      files = await fm.filesTree( 
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["mp3"] //optional, to filter files, list only mp3 files
      );
      setState(() {}); //update the UI
  }

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state. 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
       SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title:Text("Local Music",
        style: GoogleFonts.aBeeZee(
color: Colors.black,
fontSize: 18,
        ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body:files == null? Text("Searching Files"):
           ListView.builder(  //if file/folder list is grabbed, then show here
              itemCount: files?.length ?? 0,
              itemBuilder: (context, index) {
                    return Card(
                      child:ListTile(
                        
                         title: Text(files[index].path.split('/').last,
                         style: GoogleFonts.aBeeZee(
                           color: Colors.blueGrey,
                           fontSize: 16
                         ),
                         
                         ),
                         leading:Image.asset("assets/allSong.png",
                        fit: BoxFit.fill,
                         
                         ),
                         trailing: Icon(Icons.play_arrow, color: Colors.redAccent,),
                         onTap: (){
                           Navigator.push(context,MaterialPageRoute(builder:(context)=>localMusicPlayer(files[index].path)) );
                         },
                      )
                    );
              },
          )
    );
  }
}