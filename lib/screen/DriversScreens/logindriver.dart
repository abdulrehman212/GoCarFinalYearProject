import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/screen/forgetpassword.dart';
import 'package:fyp_gocar/screen/main_screen.dart';
import 'package:fyp_gocar/screen/DriversScreens/signupdriver.dart';

import '../../utils/color_utils.dart';
import '../../widgets/reusable_widget.dart';
import '../../widgets/toast_message.dart';

class login_driver extends StatefulWidget {
  const login_driver({super.key});

  @override
  State<login_driver> createState() => _login_driverState();
}

class _login_driverState extends State<login_driver> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;

  void login1(BuildContext context) async {
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text)
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

  @override
  Widget build(BuildContext context) {
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
            child: Text("Welcome To Driver Portal",
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
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 5),
              child: resuableTextField("Enter Password",
                  Icons.lock_outline_rounded, true, _passwordTextController),
            ),
          ),
          forgetpassworsOption(),
          SizedBox(
            height: 10,
          ),
          logInButton(context, true, () {
            login1(context);
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
                MaterialPageRoute(builder: (context) => Signupdriver()));
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

  Row forgetpassworsOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const Text("Forget Password", style: TextStyle(color: Colors.black)),
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
                  fontStyle: FontStyle.normal),
            ),
          ),
        )
      ],
    );
  }
}
