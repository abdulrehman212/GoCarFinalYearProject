import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/screen/UsersSreen/loginuser.dart';
import 'package:fyp_gocar/screen/otp.dart';
import 'package:fyp_gocar/screen/phoneOtpVerification.dart';
import 'package:fyp_gocar/widgets/reusable_widget.dart';

import '../../utils/color_utils.dart';

class signupusers extends StatefulWidget {
  const signupusers({super.key});

  @override
  State<signupusers> createState() => signupusersState();
}

// ignore: camel_case_types
class signupusersState extends State<signupusers> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  String? useremail;
  String phone = '';

  final firebaseAuth = FirebaseAuth.instance;

  Future signupuser() async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailTextController.text.trim(),
      password: _passwordTextController.text.trim(),
    );

    addUserDetails(
      _usernameTextController.text.trim(),
      emailTextController.text.trim(),
      _phoneTextController.text.trim(),
      _phoneTextController.text.trim(),
    );
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             Otpverification(useremail: useremail, phone: phone)));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhoneNumberOTPScreen(phoneNumber: phone)));
  }

  Future addUserDetails(
    String username,
    String email,
    String password,
    String Phone,
  ) async {
    await FirebaseFirestore.instance.collection('usersData').add({
      'username': username,
      'email': email,
      'phone': Phone,
    });
  }

  validateForm() {
    if (_usernameTextController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 charachers!");
    } else if (emailTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Email required, please enter an Email");
    } else if (!emailTextController.text.contains("@")) {
      Fluttertoast.showToast(msg: "email is not valid");
    } else if (!_phoneTextController.text.contains(RegExp(r'[0-9]'))) {
      Fluttertoast.showToast(
          msg: "please enter valid phone number" "\n 03xx xxxx xxx");
    } else if (_phoneTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "please enter Phone Number !");
    } else if (_passwordTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "please enter password");
    } else if (_passwordTextController.text.length < 6) {
      Fluttertoast.showToast(msg: "password must be atleast 6 charachters");
    } else {
      useremail = emailTextController.text;
      setState(() {
        phone = _phoneTextController.text;
      });
      signupuser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 252, 245, 245),
          Color.fromARGB(255, 252, 245, 245),

          // hexStringToColor("E845D6"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Image.asset("assets/BGauthImage.png"),
              ),
            ),
            Container(
              child: Text("Please Enter User Details!",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: hexStringToColor("#1F1F1F"),
                      fontSize: 16,
                      fontStyle: FontStyle.italic)),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuableTextField("Enter useranme", Icons.person, false,
                    _usernameTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuableTextField("Enter user Email",
                    Icons.email_rounded, false, emailTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuableTextField("Enter Password",
                    Icons.lock_outline_rounded, true, _passwordTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuableTextField("Enter Phone Number",
                    Icons.phone_android_rounded, false, _phoneTextController),
              ),
            ),
            SignUpButton(context, false, () {
              validateForm();
            }
                //signupuser();

                ),
            returnToLogin1(context),
          ],
        )),
      ),
    );
  }
}

Row returnToLogin1(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Already Have An Account?",
          style: TextStyle(color: Colors.black)),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginUser()));
        },
        child: const Text(
          " Login",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      )
    ],
  );
}
