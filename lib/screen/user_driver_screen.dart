//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fyp_gocar/screen/DriversScreens/logindriver.dart';
import 'package:fyp_gocar/screen/UsersSreen/loginuser.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class user_driver_screen_view extends StatefulWidget {
  const user_driver_screen_view({super.key});

  @override
  State<user_driver_screen_view> createState() =>
      _user_driver_screen_viewState();
}

class _user_driver_screen_viewState extends State<user_driver_screen_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 245, 245),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(child: Image.asset("assets/App_logo.png")),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(90)),
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('userType', 'user');

                  setState(() {
                    isUser = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginUser(),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        //return Color.fromARGB(255, 35, 238, 79);
                        return Colors.blueGrey;
                      }
                      return hexStringToColor("#4364F7");
                    }),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)))),
                child: const Text(
                  'LOGIN AS USER',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(
                    //color: const Color(0XFFFF6787),
                    color: hexStringToColor("#4364F7"),
                    style: BorderStyle.solid,
                    width: 2.5,
                  )),
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('userType', 'driver');
                  setState(() {
                    isUser = false;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => login_driver(),
                    ),
                  );
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith<double>(
                      // As you said you don't need elevation. I'm returning 0 in both case
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return 0;
                        }
                        return 0; // Defer to the widget's default.
                      },
                    ),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blueGrey;
                      }
                      return Color.fromARGB(206, 202, 223, 223);
                    }),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
                child: const Text(
                  'LOGIN AS DRIVER',
                  style: TextStyle(
                      color: Color.fromARGB(255, 72, 16, 226),
                      // color: Colors.,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}

bool? isUser;
