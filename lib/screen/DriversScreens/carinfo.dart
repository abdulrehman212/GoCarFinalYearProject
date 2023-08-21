import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/screen/DriversScreens/logindriver.dart';
import '../../widgets/reusable_widget.dart';

class Carinfoscreen extends StatefulWidget {
  const Carinfoscreen({super.key});

  @override
  State<Carinfoscreen> createState() => _CarinfoscreenState();
}

class _CarinfoscreenState extends State<Carinfoscreen> {
  TextEditingController _carnameTextController = TextEditingController();
  TextEditingController _carNumberTextController = TextEditingController();
  TextEditingController _carcolorTextController = TextEditingController();

  carvalidation() {
    if (_carNumberTextController.text.length < 4) {
      Fluttertoast.showToast(msg: "enter correct number");
    } else if (_carNumberTextController.text.isNotEmpty) {
      Fluttertoast.showToast(msg: "Car number is Required");
    } else if (_carnameTextController.text.isNotEmpty) {
      Fluttertoast.showToast(msg: "Car name is Required");
    } else if (_carcolorTextController.text.isNotEmpty) {
      Fluttertoast.showToast(msg: "Car color is Required");
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
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Container(
                  child: Image.asset("assets/login.png"),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
                child: resuableTextField("Enter Car Name", Icons.car_rental,
                    false, _carnameTextController),
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
              //carvalidation();
              if (_carNumberTextController.text.isNotEmpty &&
                  _carcolorTextController.text.isNotEmpty &&
                  _carnameTextController.text.isNotEmpty) ;
              {
                //saveCarInfo();
              }
            }),
          ]),
        ),
      ),
    );
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
