import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/screen/DriversScreens/driver_ride.dart';
import 'package:fyp_gocar/screen/DriversScreens/ratingScreen.dart';
import 'package:fyp_gocar/screen/FeedbackScreen.dart';
import 'package:fyp_gocar/screen/UsersSreen/cancelbooking.dart';
import 'package:fyp_gocar/tabpages/subScreen/FAQs_Screen.dart';
import 'package:fyp_gocar/tabpages/subScreen/Safety.dart';
import 'package:ionicons/ionicons.dart';
import '../utils/color_utils.dart';
import '../widgets/settings_tile.dart';
import '../widgets/toast_message.dart';

class SettingsTabPage extends StatefulWidget {
  const SettingsTabPage({super.key});

  @override
  State<SettingsTabPage> createState() => _SettingsTabPageState();
}

class _SettingsTabPageState extends State<SettingsTabPage> {
  var style;

  String currentUsertype = '';

  checkUserType() async {
    final FirebaseAuth firesbase_auth = FirebaseAuth.instance;
    final User? newtempUser = firesbase_auth.currentUser;
    print('printing email ------------>    ' + newtempUser!.email.toString());

    if (await getUserCollectionName(newtempUser.email!) == 'usersData') {
      setState(() {
        currentUsertype = 'user';
      });
    } else if (await getUserCollectionName(newtempUser.email!) ==
        'DriverData') {
      setState(() {
        currentUsertype = 'driver';
      });
    }
  }

  Widget settingsWidget() {
    if (currentUsertype == 'user') {
      return SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            const Text(
              "Settings",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              color: Colors.blue,
              icon: Ionicons.person_circle_outline,
              title: "Account",
              onTap: () {
                displayToastMessage(
                    "You are Logged in as: " + user.email!, context);
              },
            ),
            // const SizedBox(
            //   height: 25,
            // ),
            // SettingsTile(
            //   color: Colors.green,
            //   icon: Ionicons.notifications,
            //   title: "Notifications testing",
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => const Hometest()));
            //   },
            // ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.black,
              icon: Ionicons.car_sport,
              title: "Current Ride",
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CancelMyBooking()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.purple,
              icon: Ionicons.shield_checkmark_sharp,
              title: "Safety",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Safety()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.red,
              icon: Ionicons.chatbox_sharp,
              title: "Feedback and Support",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.cyan,
              icon: Ionicons.help,
              title: "FAQs",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FAQScreen()));
              },
            ),
          ],
        ),
      ));
    } else if (currentUsertype == 'driver') {
      return SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            const Text(
              "Settings",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            SettingsTile(
              color: Colors.blue,
              icon: Ionicons.person_circle_outline,
              title: "Account",
              onTap: () {
                displayToastMessage(
                    "You are Logged in as: " + user.email!, context);
              },
            ),
            // const SizedBox(
            //   height: 25,
            // ),
            // SettingsTile(
            //   color: Colors.green,
            //   icon: Ionicons.notifications,
            //   title: "Notifications testing",
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => const Hometest()));
            //   },
            // ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.black,
              icon: Ionicons.car_sport,
              title: "Your Booked Ride",
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CancelMyBooking()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.amber,
              icon: Ionicons.star_sharp,
              title: "Your Ratings",
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RatingScreen()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.blueGrey,
              icon: Ionicons.car_outline,
              title: "Offered Ride",
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const driverRides()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.purple,
              icon: Ionicons.shield_checkmark_sharp,
              title: "Safety",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Safety()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.red,
              icon: Ionicons.chatbox_sharp,
              title: "Feedback and Support",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            SettingsTile(
              color: Colors.cyan,
              icon: Ionicons.help,
              title: "FAQs",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FAQScreen()));
              },
            ),
          ],
        ),
      ));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserType();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: hexStringToColor('#4364F7'),
        textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        title: Text("Settings Page"),
        backgroundColor: hexStringToColor('#4364F7'),
        surfaceTintColor: Colors.black12,
        automaticallyImplyLeading: false,
      ),
      body: settingsWidget(),
    );
  }
}
