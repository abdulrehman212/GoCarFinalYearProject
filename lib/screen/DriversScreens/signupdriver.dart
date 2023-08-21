import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/screen/DriversScreens/logindriver.dart';
import 'package:fyp_gocar/screen/otp.dart';
import '../../utils/color_utils.dart';
import '../../widgets/reusable_widget.dart';

class Signupdriver extends StatefulWidget {
  const Signupdriver({super.key});

  @override
  State<Signupdriver> createState() => _SignupdriverState();
}

class _SignupdriverState extends State<Signupdriver> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _carnameTextController = TextEditingController();
  TextEditingController _carNumberTextController = TextEditingController();
  TextEditingController _carcolorTextController = TextEditingController();

  //DocumentSnapshot snapshot;

  final firebaseAuth = FirebaseAuth.instance;

  final _formkey = GlobalKey<FormState>();

  Future signupdriver() async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: _emailTextController.text.trim(),
      password: _passwordTextController.text.trim(),
    );

    adddriverDetails(
      _usernameTextController.text.trim(),
      _emailTextController.text.trim(),
      _phoneTextController.text.trim(),
      _carnameTextController.text.trim(),
      _carNumberTextController.text.trim(),
      _carcolorTextController.text.trim(),

      //_phoneTextController.text.trim(),
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Otpverification(
                  useremail: _emailTextController.text,
                  phone: _phoneTextController.text,
                )));
  }

  Future adddriverDetails(
    String username,
    String email,
    String Phone,
    String carmodel,
    String carnumber,
    String carcolor,
  ) async {
    await FirebaseFirestore.instance.collection('DriverData').add({
      'username': username,
      'email': email,
      'phone': Phone,
      'car model': carmodel,
      'car number': carnumber,
      'car color': carcolor
    });
  }

  validateForm() {
    if (_usernameTextController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 charachers!");
    } else if (_emailTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Email required, please enter an Email");
    } else if (!_emailTextController.text.contains("@")) {
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
    } else if (_carNumberTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Car number is Required");
    } else if (_carnameTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Car name is Required");
    } else if (_carcolorTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Car color is Required");
    } else {
      signupdriver();
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
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Image.asset("assets/BGauthImage.png"),
              ),
            ),
            Container(
              child: Text("Please Enter Driver Details!",
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
                child: resuableTextField("Enter username", Icons.person, false,
                    _usernameTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuableTextField("Enter Email-ID ",
                    Icons.email_outlined, false, _emailTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuableTextField("Enter Password",
                    Icons.lock_clock_sharp, true, _passwordTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: resuable_passTextField(
                  "Enter Phone Number",
                  Icons.phone_android_outlined,
                  true,
                  _phoneTextController,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 1, 12, 5),
                child: resuableTextField("Enter Car Name",
                    Icons.car_rental_rounded, false, _carnameTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 1, 12, 5),
                child: resuableTextField("Enter Car Number",
                    Icons.numbers_rounded, false, _carNumberTextController),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 1, 12, 5),
                child: resuableTextField("Enter Car Color", Icons.color_lens,
                    false, _carcolorTextController),
              ),
            ),
            SignUpButton(context, false, () {
              validateForm();
              //saveDriverInfo();
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Carinfoscreen()));*/
            }),
            returnToLogin()
          ],
        ),
      ),
    ));
  }

  Row returnToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already Have An Account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => login_driver()));
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
}
