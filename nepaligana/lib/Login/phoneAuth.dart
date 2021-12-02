import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'phontAuthOtp.dart';
class PhoneAuthincation extends StatefulWidget {
  @override
  _PhoneAuthincationState createState() => _PhoneAuthincationState();
}

class _PhoneAuthincationState extends State<PhoneAuthincation> {
  TextEditingController _phoneNumber = TextEditingController();
  bool checkNumberLength=false;
  String countryCode="+977";
  SmsAutoFill _smsAutoFill=SmsAutoFill();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumber.text="";
  }
  @override
  Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Align(
              alignment: Alignment.center,
              child: Text(
                "Hello, Enter Your Mobile Number",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        maxLength: checkNumberLength==true?10:null,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                        controller: _phoneNumber,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            prefixIcon: CountryCodePicker(
                              enabled: true,
                              onChanged: (c){
                                setState(() {
                                  countryCode=c.dialCode;
                                  print(countryCode);
                                });
                              },
                              initialSelection: 'NP',
                              showDropDownButton: true,
                              textStyle: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: false,
                              favorite: ['+977', 'NP'],
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _phoneNumber.text = "";
                                  });
                                }),
                                ),
onChanged: (value){
  if(value.length<10){
    setState(() {
      checkNumberLength=false;
      
    });
  }else if(value.length==10){
    setState(() {
      checkNumberLength=true;
    });
  }
  print(checkNumberLength);
},

                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
height: 30,
            ),
            // continue button 
             GestureDetector(
              onTap: ()  {
                if(checkNumberLength==true){
 var compleatPhone=countryCode+_phoneNumber.text;
 Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(compleatPhone)));
             print(compleatPhone);
                }else{
                  Fluttertoast.showToast(msg: "The phone Number is not valid ",
                  textColor: Colors.orange,
                  backgroundColor: Colors.white,
                  );
                }
            
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:checkNumberLength==true? Colors.red:Colors.black54,
                ),
                child: Center(
                  child: Text(
                    "Get OTP",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),


            //text of suggestion

            SizedBox(
height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "By Processing you agree to the Terms of Use of Nepali Gaana",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
