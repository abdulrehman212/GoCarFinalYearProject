import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/screen/VerifyPhoneOTP.dart';
import 'package:fyp_gocar/widgets/snack_bar.dart';
import '../utils/color_utils.dart';
import '../widgets/reusable_widget.dart';

class SendPhone_OTP extends StatefulWidget {
  const SendPhone_OTP({super.key});

  @override
  State<SendPhone_OTP> createState() => _SendPhone_OTPState();
}

class _SendPhone_OTPState extends State<SendPhone_OTP> {
  FocusNode focusNode = FocusNode();
  static String verify = '';

  final TextEditingController _OTPphonenumberController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";

  Future<void> verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      _auth.signInWithCredential(authResult).then((UserCredential value) {
        if (value.user != null) {
          print("Handle logged in user");
        } else {
          print("Error occurred");
        }
      }).catchError((error) {
        print("Error occurred: " + error.toString());
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Verification failed: ${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResendingToken]) {
      verificationId = verId;

      print('verification id is: ' + verificationId.toString());

      print(_OTPphonenumberController.text);
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      verificationId = verId;
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: _OTPphonenumberController.text,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
    showSnackBar(context, "OTP Code has been send!");
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, animationTime) {
          return VerifyPhone_OTP(
            verification_id: verificationId,
          );
        },
      ),
      (route) => false,
    );
  }

  /* final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential authResult) async {
    // Here you should ask the user to input the SMS code, then create the AuthCredential with verificationId and SMS code
    String smsCode =
        await getUserInput(); // getUserInput() should be your method to get user input
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    _auth.signInWithCredential(credential).then((UserCredential value) {
      if (value.user != null) {
        print("Handle logged in user");
      } else {
        print("Error occurred");
      }
    }).catchError((error) {
      print("Error occurred: " + error.toString());
    });
  };*/

  /*late Timer timer;
  int second = 60;
  late bool isButtonActive = false;
  String buttonname = "Send";

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (second == 0) {
          setState(() {
            isButtonActive = true;
            timer.cancel();
            isButtonActive = false;
          });
        } else {
          setState(() {
            second--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(child: Image.asset("assets/otp.png")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "OTP Verification!",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: hexStringToColor("#1F1F1F"),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "OTP Code will be Send On Your Mobile ",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: hexStringToColor("#1F1F1F"),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Enter Your Mobile Number Below ",
                textAlign: TextAlign.right,
                //textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: hexStringToColor("#1F1F1F"),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),*/
            SizedBox(height: 30),
            RichText(
              text: TextSpan(children: [
                const TextSpan(
                  text: "Enter Your Mobile Number Below ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 7, 5, 5),
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                child: resuablephoneTextField(
                  "Enter number like +92 336****780",
                  Icons.phone_android_rounded,
                  false,
                  _OTPphonenumberController,
                ),
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.all(11.0),
              child: IntlPhoneField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: '3374166***',
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(38),
                    gapPadding: 5.0,
                  ),
                ),
                languageCode: "en",
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
              ),
            ),*/
            ElevatedButton(
              onPressed: () {
                /* await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, forceResendingToken) {
                    
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, animationTime) {
                            return const VerifyPhone_OTP();
                          },
                        ),
                        (route) => false,
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {});*/

                verifyPhoneNumber();
                //verificationCompleted
                /**/
              },
              child: Text('Send OTP'),
            ),
            SizedBox(
              height: 15,
            ),
            /*RichText(
              text: TextSpan(children: [
                const TextSpan(
                  text: "Click Send OTP again in ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 7, 5, 5),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "00:$second",
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Color(0XFFFF4F5A),
                      fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " Sec",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 7, 5, 5),
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),*/
          ],
        ),
      ),
    );
  }
}
