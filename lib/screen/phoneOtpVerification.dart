import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/screen/UsersSreen/loginuser.dart';

class PhoneNumberOTPScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneNumberOTPScreen({required this.phoneNumber});

  @override
  State<StatefulWidget> createState() => _PhoneNumberOTPScreenState();
}

class _PhoneNumberOTPScreenState extends State<PhoneNumberOTPScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isverified = false;

  String _verificationId = '';

  Future<void> _sendOTP() async {
    String phoneNumber = _phoneNumberController.text.trim();

    // Validate the phone number
    if (!_isValidPhoneNumber(phoneNumber)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Phone Number'),
            content: Text('Please enter a valid phone number.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('code verified ');
        // Automatic verification if SMS code is detected
        // UserCredential userCredential =
        //     await _auth.signInWithCredential(credential);
        // User? user = userCredential.user;
        // if (user != null) {
        //   // User signed in successfully
        //   print('User signed in with phone number: ${user.phoneNumber}');
        //   setState(() {
        //     isverified = true;
        //   });
        //   // Redirect to the home screen or perform any necessary actions
        // }
        setState(() {
          isverified = true;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print('Verification failed: $e');
        // Display an error message to the user or handle the failure gracefully
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID for later use
        setState(() {
          _verificationId = verificationId;
        });
        print('code sent');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Timeout for automatic code retrieval
        setState(() {
          _verificationId = verificationId;
        });
        print('>>>>>>>>>>>     codeAutoRetrievalTimeout    >>>>>>>>>');
      },
    );
    // Send OTP to the provided phone number
    print('Sending OTP to $phoneNumber');
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Remove any spaces from the phone number
    phoneNumber = phoneNumber.replaceAll(' ', '');

    // Check if the phone number matches the required format
    RegExp regExp = RegExp(r'^\+92[3-9]\d{9}$');
    return regExp.hasMatch(phoneNumber);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        '############################             phone number              #############################################');
    print(widget.phoneNumber);
    // _phoneNumberController.text = widget.phoneNumber;

    _phoneNumberController.text = "+92";
    _phoneNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneNumberController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text('Send OTP'),
            ),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isverified == true) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => LoginUser()));
                } else {
                  print('user is not verified');
                }
              },
              child: Text('Go to Login page'),
            )
          ],
        ),
      ),
    );
  }
}
