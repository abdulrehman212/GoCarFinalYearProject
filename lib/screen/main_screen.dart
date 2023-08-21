import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/tabpages/home_tabpage.dart';
import 'package:fyp_gocar/tabpages/profile_tab.dart';
import 'package:fyp_gocar/tabpages/settings.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:fyp_gocar/utils/testing.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final firebaseInstance = FirebaseFirestore.instance;
  FirebaseAuth authController = FirebaseAuth.instance;
  // final DataController controller = Get.put(DataController());
  
  // final DataController controller1 = Get.find();
  final tabs = [
    const ProfileTabPage(),
    const HomeTabPage(),
    const SettingsTabPage(),
  ];
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.person, size: 22),
      Icon(Icons.home, size: 22),
      Icon(Icons.settings, size: 22),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      /*appBar: AppBar(
        title: Text("Home page"),
        backgroundColor: hexStringToColor('#4364F7'),
        surfaceTintColor: Colors.black12,
      ),*/
      body: tabs[_index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: hexStringToColor('#4364F7'),
          buttonBackgroundColor: hexStringToColor('#4364F7'),
          animationDuration: Duration(milliseconds: 500),
          height: 57,
          items: items,
          index: _index,
          onTap: (index) async {
            setState(() => this._index = index);
           
            // print(",,,,,,,,,,,,,,,,${response.docs.first.data()},,,,$c......");
          },
        ),
      ),
    );
  }
}
