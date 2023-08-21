import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/screen/forgetpassword.dart';
import 'package:fyp_gocar/screen/UsersSreen/signupuser.dart';
import 'package:fyp_gocar/widgets/reusable_widget.dart';

import '../../utils/color_utils.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/toast_message.dart';
import '../main_screen.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => LoginUserState();
}

class LoginUserState extends State<LoginUser> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;

  var userId;

  @override
  Widget build(BuildContext context) {
    void login(BuildContext context) async {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      )

          /* if (userCredential.user != null) {
        
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        
      } else {
        displayToastMessage("User is null", context);
      }*/

          .catchError(
        (errMsg) {
          if (errMsg.code == "user-not-found") {
            displayToastMessage(
                "Login details are incorrect" + "\n no such User available",
                context);
          } else if (errMsg.code == "wrong-password") {
            displayToastMessage("Password is wrong", context);
          } else if (errMsg.code == "invalid-email") {
            displayToastMessage(
                "Email format is not valid" + "\n please enter correct email",
                context);
          } else {
            displayToastMessage("Error: $errMsg", context);
            //Fluttertoast.showToast(msg: "welcome to home page");
          }
        },
      );
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, animationTime) {
            return MainScreen();
          },
        ),
        (route) => false,
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Container(child: Image.asset("assets/login.png"))),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Welcome To User Portal",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hexStringToColor("#1F1F1F"),
                    fontSize: 20,
                    fontStyle: FontStyle.italic)),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: resuableTextField("Enter User Email", Icons.email_rounded,
                  false, _emailTextController),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 5),
            child: resuableTextField("Enter Password",
                Icons.lock_outline_rounded, true, _passwordTextController),
          ),
          forgetpasswordOption(),
          SizedBox(
            height: 10,
          ),
          logInButton(context, true, () {
            login(context);
          }),
          signUpOption(),
        ],
      )),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't Have Account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => signupusers()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      ],
    );
  }

  Row forgetpasswordOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Forgetpassword()));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 27, 10),
            child: const Text(
              "FORGET PASSWORD",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        )
      ],
    );
  }
}
