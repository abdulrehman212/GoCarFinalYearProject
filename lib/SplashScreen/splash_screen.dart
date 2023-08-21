import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/screen/main_screen.dart';
import 'package:fyp_gocar/screen/notification_services.dart';
import 'package:fyp_gocar/screen/user_driver_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => MySplashScreenState();
}

class MySplashScreenState extends State<MySplashScreen> {
  static const String KEYLOGIN = "login";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Color.fromARGB(255, 252, 245, 245),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 233, 234, 236),
                  Color.fromARGB(0, 114, 140, 211),
                  //Color.fromARGB(0, 148, 225, 228),
                  // Color.fromARGB(246, 231, 20, 20),
                  /* Color.fromARGB(244, 231, 192, 198),
                  Color.fromARGB(244, 107, 157, 233),*/
                ]),
            image: DecorationImage(
              image: AssetImage('assets/App_logo.png'),
              // fit: BoxFit.fitHeight,
            )),

        child: Container(),

        //#d10101   red
        //#05434e  green

        //  child: Container(),

        /*child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/splashimage.jpg"),
            ),
            //Image.asset("assets/gocarlogo.png"),

            /*const SizedBox(
              height: 5,
            ),
            const Text("GoCar Carpooling App",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black38,
                  //fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w600,
                )
                )*/
          ],
        )),*/
      ),
    );
  }

  void whereToGo() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getBool(KEYLOGIN);

    Timer(const Duration(seconds: 1), () async {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          /* Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));*/

          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, animationTime) {
                return MainScreen();
              },
            ),
            (route) => false,
          );
        } else {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => const user_driver_screen_view()));*/
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, animationTime) {
                return user_driver_screen_view();
              },
            ),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, animationTime) {
              return user_driver_screen_view();
            },
          ),
          (route) => false,
        );
      }
    });
  }
}
