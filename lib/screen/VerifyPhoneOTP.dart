import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/screen/main_screen.dart';
import 'package:fyp_gocar/screen/user_driver_screen.dart';

import '../utils/color_utils.dart';
import '../widgets/reusable_widget.dart';

class VerifyPhone_OTP extends StatefulWidget {
  const VerifyPhone_OTP({super.key, this.verification_id});

  final String? verification_id;

  @override
  State<VerifyPhone_OTP> createState() => _VerifyPhone_OTPState();
}

class _VerifyPhone_OTPState extends State<VerifyPhone_OTP> {
  final TextEditingController _OTPphonenumberverifyController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? _verificationId; // Make _verificationId nullable

  // Verify the entered OTP
  /*void _verifyOTP(String otp) async {
    if (widget.verification_id! == '') {
      // Handle the case when verification ID is null
      print('Verification ID is null. Cannot verify OTP.');
      return;
    }

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId:
            widget.verification_id!, // Use the stored verification ID
        smsCode: otp,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // OTP verification successful
        // Add your desired navigation or functionality here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => user_driver_screen_view()),
        );
      } else {
        // OTP verification failed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed'),
              content: Text('Invalid OTP. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Error occurred during OTP verification
      print('--------------------------');
      print('Error verifying OTP: $e');
      Fluttertoast.showToast(
          msg: "Error coming while verifying OTP:" + "\n $e");
    }
  }*/
  Future<void> _signInWithOTP() async {
    print('-----------------------------------------------');
    print(_OTPphonenumberverifyController);
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verification_id!,
        smsCode: _OTPphonenumberverifyController.text,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => user_driver_screen_view()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed'),
              content: Text('Invalid OTP. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error occurred during sign in with OTP: $e');
      Fluttertoast.showToast(
          msg: "Error coming while signing in with OTP:" + "\n$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 238, 238),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: Image.asset("assets/otp_pic.png")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            SizedBox(height: 30),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                child: resuablephoneTextField(
                  "Enter your OTP code",
                  Icons.verified_user_rounded,
                  false,
                  _OTPphonenumberverifyController,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String otp = _OTPphonenumberverifyController.text;
                _signInWithOTP(); // Call the new method

                // PhoneAuthCredential credential= PhoneAuthProvider.credential(verificationId: widget.verification_id , smsCode: smsCode)
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
