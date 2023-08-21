import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/screen/user_driver_screen.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:fyp_gocar/widgets/progress_bar.dart';

import '../widgets/reusable_widget.dart';
import '../widgets/toast_message.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController _emailTextController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text.trim());
      /* ProgressBar(
          message: "Link has been send" + "\nplease check your email or spam");*/
      Fluttertoast.showToast(
          msg: "Link has been send" + "\nplease check your email or spam");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => user_driver_screen_view()));
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not exist");
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: "Email format is invalid");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 245, 245),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.all(38.0),
            child: Center(
                child:
                    Container(child: Image.asset("assets/BGsignupimage.png"))),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Forget Password!",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hexStringToColor("#1F1F1F"),
                    fontSize: 20,
                    fontStyle: FontStyle.italic)),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: resuableTextField("Enter Email-ID To Reset Password ",
                  Icons.email_rounded, false, _emailTextController),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          forgetPasswordButton(context, false, () async {
            if (_emailTextController.text.isEmpty) {
              displayToastMessage("Please enter email", context);
            } else if (!_emailTextController.text.contains('@')) {
              displayToastMessage("Email is not valid", context);
            } else {
              passwordReset();
            }
          }),
        ])));
  }

  Container forgetPasswordButton(
      BuildContext context, bool isLogin, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 4),
        child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            "Submit",
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black26;
                }
                return hexStringToColor("#4364F7");
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
        ),
      ),
    );
  }
}
