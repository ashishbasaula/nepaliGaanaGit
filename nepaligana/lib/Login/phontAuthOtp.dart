import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:nepaligana/Dashboard/dashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState(phone);
}

class _OTPScreenState extends State<OTPScreen> {
  String phoneNumber;
  _OTPScreenState(this.phoneNumber);
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.black38,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.white,
    ),
  );
  final BoxDecoration selectedField = BoxDecoration(
    color: Colors.lightGreen,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.white,
    ),
  );

  String otpPin;
  bool checkOtpLength = false;
String timer;
  Timer _timer;
int _start = 120;

  @override
  Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        toolbarHeight: 30,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
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
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Enter the 6-digit code send to " + phoneNumber,
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: PinPut(
                  fieldsCount: 6,
                  textStyle:
                      GoogleFonts.aBeeZee(color: Colors.red, fontSize: 20),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 50.0,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: selectedField,
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.fade,
                  onSubmit: (pin) async {
                    setState(() {
                      otpPin = pin;
                      if (otpPin.length == 6) {
                        setState(() {
                          checkOtpLength = true;
                        });
                      }
                    });
                  }),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              if (otpPin.length == 6) {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: otpPin))
                      .then((value) async {
                    if (value.user != null) {
                       SharedPreferences _pref = await SharedPreferences.getInstance();
                       _pref.setString("userId", value.user.uid);
               FirebaseFirestore.instance.collection("userProfile").doc(value.user.uid).set({
   "UserName": value.user.phoneNumber,
          "UserId": value.user.uid,
          "UserEmail": value.user.email,
          "UserPhoto": value.user.photoURL,
          }).then((value)async {
   SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setBool("loginCheck", true);
       
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoard("Phone")));
          });
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  Fluttertoast.showToast(msg: "You Have Enter Wrong OTP");
                }
              } else {
                Fluttertoast.showToast(
                    msg: "You Dont Have Enter 6- digit Code");
              }
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: checkOtpLength == true ? Colors.red : Colors.black54,
              ),
              child: Center(
                child: Text(
                  "Log In ",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
height: 20,
          ),
          Center(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Didn't receive OTP ? Resend Code In "+_start.toString(),
                style: GoogleFonts.aBeeZee(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {

          SharedPreferences _pref = await SharedPreferences.getInstance();
                       _pref.setString("userId", value.user.uid);
               FirebaseFirestore.instance.collection("userProfile").doc(value.user.uid).set({
   "UserName": value.user.displayName,
          "UserId": value.user.uid,
          "UserEmail": value.user.email,
          "UserPhoto": value.user.photoURL,
          }).then((value)async {
   SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setBool("loginCheck", true);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoard("Phone")));
          });
      
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
    startTimer();
  }


void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          _verifyPhone();
          Fluttertoast.showToast(msg: "Code Has Been Send");
          timer.cancel();

        });
      } else {
        setState(() {
          _start--;
          print(_start);
        });
      }
    },
  );
}
}
