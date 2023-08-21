import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/message_screen.dart';
import 'package:fyp_gocar/screen/OfferRide/offerride.dart';
import 'package:fyp_gocar/screen/availableRides.dart';
import 'package:fyp_gocar/screen/userPoolScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notificationservice/local_notification_services.dart';
import '../utils/color_utils.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  // NotificationServices notificationServices = NotificationServices();

  String currentUsertype = '';

  LocalNotificationService localNotificationService =
      LocalNotificationService();

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
      getDeviceToken();
    }
  }

  void getDeviceToken() async {
    final FirebaseAuth firesbase_auth = FirebaseAuth.instance;
    final User? newtempUser = firesbase_auth.currentUser;

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print('Device Token: $token');
        saveDeviceTokenToFirestore(token, newtempUser!.uid);
        // You can use the device token as needed in your app
      } else {
        print('Failed to get device token.');
      }
    } catch (e) {
      print('Error getting device token: $e');
    }
  }

  void saveDeviceTokenToFirestore(String token, String docId) {
    // Replace with the user's ID or any identifier you use in your app

    CollectionReference tokensCollection =
        FirebaseFirestore.instance.collection('Rides');
    tokensCollection.doc(docId).update({
      'drivertoken': token,
    }).then((value) {
      print('Device token saved to Firestore successfully.');
    }).catchError((error) {
      print('Error saving device token to Firestore: $error');
    });
  }

  clearPref() async {
    final sharedpref = await SharedPreferences.getInstance();
    sharedpref.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserType();

    // localNotificationService.handleMessage(context);

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          localNotificationService.initializeForground(context, message);
          localNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
  }

  final urlImages = [
    Image.asset(
      'assets/carpool image.png',
      fit: BoxFit.fill,
    ),
    /*Image.asset(
    'assets/images/birthday_present.jpg',
    fit: BoxFit.fill,
  ),*/
    Image.asset(
      'assets/carpooling 1.jpg',
      fit: BoxFit.fill,
    ),
    Image.asset(
      'assets/carpooling 2.png',
      fit: BoxFit.fill,
    ),
  ];
  Widget buildImage(Image img) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: Colors.grey,
        width: double.infinity,
        child: img,
      );

  Widget homeScreenWdgt() {
    if (currentUsertype == 'user') {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
              width: 200,
            ),
            Center(
              child: Card(
                elevation: 7,
                child: CarouselSlider.builder(
                  itemCount: urlImages.length,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      reverse: true,
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      viewportFraction: 1,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      aspectRatio: 16 / 9,
                      clipBehavior: Clip.hardEdge),
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = urlImages[index];

                    return buildImage(urlImage);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: (() {
                      (Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AvailableRides())));
                    }),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 30, 4, 20),
                      child: Card(
                        color: hexStringToColor('#4364F7'),
                        shadowColor: const Color.fromARGB(255, 48, 66, 66),
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Color.fromARGB(66, 0, 0, 0),
                            //color: Theme.of(context).colorScheme.surfaceTint,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox(
                          width: 150,
                          height: 105,
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "assets/carstock.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                                child: Text('Book' + '\nRide',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
        padding: EdgeInsets.only(bottom: 100),
      );
    } else if (currentUsertype == 'driver') {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
              width: 200,
            ),
            Center(
              child: Card(
                elevation: 7,
                child: CarouselSlider.builder(
                  itemCount: urlImages.length,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      reverse: true,
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      viewportFraction: 1,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      aspectRatio: 16 / 9,
                      clipBehavior: Clip.hardEdge),
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = urlImages[index];

                    return buildImage(urlImage);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              children: [
                InkWell(
                    onTap: (() {
                      (Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OfferRide())));
                    }),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 0, 20),
                      child: Card(
                        color: hexStringToColor('#4364F7'),
                        shadowColor: const Color.fromARGB(255, 48, 66, 66),
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Color.fromARGB(66, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox(
                          width: 150,
                          height: 105,
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "assets/carstock.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                                child: Text('Offer' + '\nRide',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                InkWell(
                    onTap: (() {
                      (Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AvailableRides())));
                    }),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 30, 2, 20),
                      child: Card(
                        color: hexStringToColor('#4364F7'),
                        shadowColor: const Color.fromARGB(255, 48, 66, 66),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Color.fromARGB(66, 0, 0, 0),
                            //color: Theme.of(context).colorScheme.surfaceTint,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox(
                          width: 150,
                          height: 105,
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "assets/carstock.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                                child: Text('Book' + '\nRide',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
        padding: EdgeInsets.only(bottom: 100),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home page"),
        backgroundColor: hexStringToColor('#4364F7'),
        surfaceTintColor: Colors.black12,
      ),
      body: homeScreenWdgt(),
    );
  }
}
