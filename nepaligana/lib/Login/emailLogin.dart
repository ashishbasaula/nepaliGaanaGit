import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepaligana/Dashboard/dashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController registerEmail = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  String checkUserType = "LogIn";
  bool checkColor=false;
  @override
  Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
              child: Container(
                height: 100,
                width: 190,
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage("assets/nepaliGaana.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        checkUserType = "LogIn";
                         loginEmail.text="";
                  loginPassword.text="";
                      });
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.aBeeZee(
                        color:checkUserType=="LogIn"? Colors.red:Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Text(
                    "oR",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        checkUserType = "Register";
                         registerEmail.text="";
                  registerPassword.text="";
                      });
                    },
                    child: Text(
                      "Register",
                      style: GoogleFonts.aBeeZee(
                        color: checkUserType=="Register"? Colors.red:Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: loginOrRegister(),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginOrRegister() {
    if (checkUserType == "LogIn") {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: loginEmail,
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        loginEmail.text="";
                      });
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // password
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: loginPassword,
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
             // obscuringCharacter: "@",
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        loginPassword.text="";
                      });
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              if (loginEmail.text == "" || loginPassword.text == ""||loginPassword.text.length<6) {
                Fluttertoast.showToast(
                    msg: "Please Enter Valid Email And Password");
                   
              } else {
                try {
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  UserCredential user = await _auth.signInWithEmailAndPassword(
                      email: loginEmail.text, password: loginPassword.text).then((value)async{
                                  SharedPreferences _pref = await SharedPreferences.getInstance();
                       _pref.setString("userId", value.user.uid);
    await  FirebaseFirestore.instance.collection("userProfile").doc(value.user.uid).set({
   "UserName": value.user.displayName,
          "UserId": value.user.uid,
          "UserEmail": value.user.email,
          "UserPhoto": value.user.photoURL,
          }).then((value)async {
   SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setBool("loginCheck", true);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoard("Email")));
          });
      
                      });
               
                  Fluttertoast.showToast(msg: "login Success Full");
                
    
                 
                } on PlatformException catch(e) {
                  print(e.message);
                  Fluttertoast.showToast(msg: e.message);
                }
              }
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  "Log In",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (checkUserType == "Register") {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: registerEmail,
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        registerEmail.text="";
                      });
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // password
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: registerPassword,
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              //obscuringCharacter: "@",
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        registerPassword.text="";
                      });
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              if (registerEmail.text == "" || registerPassword.text == ""||registerPassword.text.length<6) {
                Fluttertoast.showToast(
                    msg: "Please Enter Valid Email And Password");
              } else {
                try {
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  UserCredential user =
                      await _auth.createUserWithEmailAndPassword(
                          email: registerEmail.text, password: registerPassword.text);
                  Fluttertoast.showToast(msg: "User Created Success Fully");
                  registerEmail.text="";
                  registerPassword.text="";
                  setState(() {
                    checkUserType="LogIn";
                  });
                } catch(e){
                  print(e.message);
                }
              }
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  "Register",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
