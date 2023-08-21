import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/screen/main_screen.dart';
import 'package:fyp_gocar/screen/starRating.dart';
import 'package:fyp_gocar/tabpages/home_tabpage.dart';
import 'package:fyp_gocar/utils/color_utils.dart';

class CancelMyBooking extends StatefulWidget {
  const CancelMyBooking({super.key});

  @override
  State<CancelMyBooking> createState() => _CancelMyBookingState();
}

class _CancelMyBookingState extends State<CancelMyBooking> {
  double userfare = 0.0;
  //  FirebaseAuth newauth = FirebaseAuth.instance;
  User? newUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDriverDoc(
      String? Email) async {
    final rides = FirebaseFirestore.instance.collection('DriverData');
    final rideQuery = await rides.where('email', isEqualTo: Email).get();
    final ridedocs = rideQuery.docs;

    if (ridedocs.isNotEmpty) {
      final rideDoc = ridedocs.first;
      return rideDoc;
    } else {
      return null!;
    }
  }

  getfare() async {
    try {
      final rideRef = FirebaseFirestore.instance
          .collection('Rides')
          .where('user_uid', arrayContains: newUser!.uid);

      final rideDoc = await rideRef.get();

      if (rideDoc.docs.isNotEmpty) {
        var data = rideDoc.docs.first.data() as Map<String, dynamic>;

        var uids = data['user_uid'];
        var index = uids.indexOf(newUser!.uid);

        if (index != -1) {
          var fare = data['user_fares'][index];
          print('Fare: $fare');

          setState(() {
            userfare = fare;
          });
        } else {
          print('User not found');
        }
      } else {
        print('No ride data found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> cancelRideAndUpdateFares(
    String rideId,
    String userUid,
  ) async {
    try {
      final rideRef =
          FirebaseFirestore.instance.collection('Rides').doc(rideId);

      final rideDoc = await rideRef.get();

      var usernames = List<String>.from(rideDoc.get('user_username') ?? []);
      var emails = List<String>.from(rideDoc.get('user_email') ?? []);
      var phones = List<String>.from(rideDoc.get('user_phone') ?? []);
      var uids = List<String>.from(rideDoc.get('user_uid') ?? []);
      var usersFare = List<double>.from(rideDoc.get('user_fares') ?? []);
      var usersKilometere =
          List<double>.from(rideDoc.get('user_kilometers') ?? []);

      var index = uids.indexOf(userUid);
      if (index == -1) {
        return 'notFound';
      }

      final numberOfSeatsAvailable = rideDoc.get('NumberOfSeatsAvailable') + 1;

      if (uids.length == 1) {
        usernames.removeAt(index);
        emails.removeAt(index);
        phones.removeAt(index);
        uids.removeAt(index);
        usersFare.removeAt(index);
        usersKilometere.removeAt(index);

        await rideRef.update({
          'user_username': usernames,
          'user_email': emails,
          'user_phone': phones,
          'user_uid': uids,
          'NumberOfSeatsAvailable': numberOfSeatsAvailable,
          'user_fares': usersFare,
          'user_kilometers': usersKilometere,
        });

        print('data at index  0 deleted');

        return 'success';
      } else if (uids.length == 2) {
        double basefare = 50.0;

        usernames.removeAt(index);
        emails.removeAt(index);
        phones.removeAt(index);
        uids.removeAt(index);
        usersFare.removeAt(index);
        usersKilometere.removeAt(index);

        await rideRef.update({
          'user_username': usernames,
          'user_email': emails,
          'user_phone': phones,
          'user_uid': uids,
          'NumberOfSeatsAvailable': numberOfSeatsAvailable,
          'user_fares': usersFare,
          'user_kilometers': usersKilometere,
        }).then((_) async {
          DocumentSnapshot ride = await rideRef.get();
          var userDistanceArray = ride.get('user_kilometers');
          var user1fare = userDistanceArray[0] * basefare;

          dynamic arrayData = ride.get('user_fares');

          if (arrayData is List && arrayData.isNotEmpty) {
            arrayData[0] = user1fare;

            await rideRef.update({'user_fares': arrayData});
          }
          print('uid index is at 1');
        });

        return 'success';
      } else if (uids.length == 3) {
        double basefare = 50.0;
        double value1 = 0.0;

        usernames.removeAt(index);
        emails.removeAt(index);
        phones.removeAt(index);
        uids.removeAt(index);
        usersFare.removeAt(index);
        usersKilometere.removeAt(index);

        await rideRef.update({
          'user_username': usernames,
          'user_email': emails,
          'user_phone': phones,
          'user_uid': uids,
          'NumberOfSeatsAvailable': numberOfSeatsAvailable,
          'user_fares': usersFare,
          'user_kilometers': usersKilometere,
        }).then((_) async {
          DocumentSnapshot rideCol = await rideRef.get();
          var userDistanceArray = rideCol.get('user_kilometers');

          var user1distance = userDistanceArray[0];
          var user2distance = userDistanceArray[1];

          double max;
          if (user1distance > user2distance) {
            max = user1distance;
            value1 = max * basefare;
          } else if (user2distance > user1distance) {
            max = user2distance;
            value1 = max * basefare;
          } else {
            // here user1distance will be probaly equal to user2distance
            max = user1distance;
          }

          double user1fare =
              (user1distance / (user1distance + user2distance)) * value1;
          double user2fare =
              (user2distance / (user1distance + user2distance)) * value1;

          dynamic arrayData = rideCol.get('user_fares');

          if (arrayData is List && arrayData.isNotEmpty) {
            arrayData[0] = user1fare;
            arrayData[1] = user2fare;

            await rideRef.update({'user_fares': arrayData});
          }
          print('uid index is at 2');
        });

        return 'success';
      } else {
        print('something went wrong !!!!!!!!!!!!!!!!!!');
      }

      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?>
      getRideForCurrentUser() async {
    final rides = FirebaseFirestore.instance.collection('Rides');
    final newUser = FirebaseAuth.instance.currentUser;

    final querySnapshot =
        await rides.where('user_email', arrayContains: newUser!.email).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the first document in the query snapshot
      return querySnapshot.docs.first;
    } else {
      // If there are no documents that match the query, return null
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        '#########################            user uid is:              ###########################3');
    print(newUser!.uid);
    getfare();
  }

  @override
  Widget build(BuildContext context) {
    // final rides = FirebaseFirestore.instance.collection('Rides');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor('#4364F7'),
        title: const Center(child: Text('Booking Details')),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future: getRideForCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No ride found with your ID '));
          } else {
            final rideData = snapshot.data!.data() as Map<String, dynamic>;

            var fare1 = userfare.toInt();

            // var userfares = rideData['user_fares'];
            // var fare = getfare(rideData['id']);

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                // Add a gradient background to the container
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(70, 132, 255, 1),
                    Color.fromRGBO(44, 62, 80, 0.473),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Card(
                    color: const Color.fromARGB(255, 210, 225, 231),
                    margin: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                    shadowColor: const Color.fromARGB(255, 194, 193, 193),
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.5,
                        style: BorderStyle.solid,
                        color: Color.fromARGB(66, 4, 0, 0),
                        //color: Theme.of(context).colorScheme.surfaceTint,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/carBlue.png',
                              width: 120,
                              height: 120,
                            ),
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                            thickness: 2,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Driver Name: ${rideData['username']} ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Phone Number: ${rideData['phone']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Source Location: ${rideData['Source']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Destination Location: ${rideData['Destination']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Date: ${rideData['Date']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Time: ${rideData['Time']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Fare: $fare1',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade300),
                          ),
                          const SizedBox(height: 7),

                          /* Text(
                            'Driver email: ${rideData['email']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),*/
                          const SizedBox(height: 12),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                            thickness: 2,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder(
                              future: getDriverDoc(rideData['email']),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> dSnapshot) {
                                if (dSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (dSnapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${dSnapshot.error}'));
                                } else if (!dSnapshot.hasData ||
                                    !dSnapshot.data!.exists) {
                                  return Center(
                                      child:
                                          Text('No ride found with your ID '));
                                } else {
                                  final driverData = dSnapshot.data!.data()
                                      as Map<String, dynamic>;

                                  final String? carcolor =
                                      driverData['car color'];
                                  final String? carnumber =
                                      driverData['car number'];
                                  final String? carmodel =
                                      driverData['car model'];
                                  print('driver email is  >  >  >      ' +
                                      rideData['email'].toString());
                                  print('doc id is  >>>>>>>>>>     : ');
                                  print(getDriverDoc(rideData['email']));

                                  return Column(
                                    children: [
                                      //const SizedBox(height: 12),
                                      Text(
                                        'Car Color: $carcolor',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Car Number: $carnumber',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Car Model: $carmodel',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  );
                                }
                              }),
                          const SizedBox(height: 12),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                            thickness: 2,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 350,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ElevatedButton.icon(
                                        onPressed: (() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) => StarRatings(
                                                        driverUid:
                                                            rideData['id'],
                                                      )));
                                        }),
                                        icon: const Icon(
                                            Icons.rate_review_rounded),
                                        label: const Text('Rate driver'),
                                        style: ElevatedButton.styleFrom(
                                          primary: hexStringToColor('#4364F7'),
                                          fixedSize: const Size(134,
                                              45), // Change the values as per your requirement
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ElevatedButton.icon(
                                        onPressed: (() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      const MainScreen()));
                                        }),
                                        icon: const Icon(Icons.home),
                                        label: const Text('Home Screen'),
                                        style: ElevatedButton.styleFrom(
                                          primary: hexStringToColor('#4364F7'),
                                          fixedSize: const Size(134,
                                              45), // Change the values as per your requirement
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton.icon(
                                    onPressed: (() async {
                                      var cancelled =
                                          await cancelRideAndUpdateFares(
                                        rideData['id'],
                                        newUser!.uid,
                                      );
                                      if (cancelled == 'notFound') {
                                        Fluttertoast.showToast(
                                            msg:
                                                "User is not Booked this ride");
                                      } else if (cancelled == 'success') {
                                        Fluttertoast.showToast(
                                            msg: "Ride canceled successfully");
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                animationTime) {
                                              return HomeTabPage();
                                            },
                                          ),
                                          (route) => false,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "An error Occured! ");
                                      }
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => const MainScreen()));*/
                                    }),
                                    icon: const Icon(Icons.cancel_outlined),
                                    label: const Text('Cancel ride'),
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color.fromARGB(
                                          255, 255, 133, 133),
                                      fixedSize: const Size(134,
                                          45), // Change the values as per your requirement
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            );
          }
        },
      ),
    );
  }
}
