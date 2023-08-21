import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/tabpages/home_tabpage.dart';
import 'package:fyp_gocar/widgets/progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color_utils.dart';

class driverRides extends StatefulWidget {
  const driverRides({super.key});

  @override
  State<driverRides> createState() => _driverRidesState();
}

class _driverRidesState extends State<driverRides> {
  // fucntion for calling a user
  void _makeCall(String phoneNumber) async {
    // Implement calling functionality here
    final Uri url = Uri(
      scheme: "tel",
      path: phoneNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ProgressBar(message: "Can't Lauch this Number...");
    }
  }

  Future<void> backupTheCollection(
      String sourceDocumentId, String backupCollection) async {
    try {
      // Get the source document from the source collection
      DocumentSnapshot sourceDocumentSnapshot = await FirebaseFirestore.instance
          .collection('Rides')
          .doc(sourceDocumentId)
          .get();

      // Check if the source document exists
      if (sourceDocumentSnapshot.exists) {
        // Get the data from the source document
        Map<String, dynamic> data =
            sourceDocumentSnapshot.data() as Map<String, dynamic>;

        // Create a new document in the backup collection
        await FirebaseFirestore.instance
            .collection(backupCollection)
            .doc(sourceDocumentId)
            .set(data)
            .then((_) async {
          try {
            await FirebaseFirestore.instance
                .collection('Rides')
                .doc(sourceDocumentId)
                .delete();
            print('Document deleted successfully');
          } catch (error) {
            print('Failed to delete document: $error');
          }
        });

        print('Document copied to backup collection successfully.');
      } else {
        print('Source document does not exist.');
      }
    } catch (e) {
      print('Error copying document to backup collection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference rides = FirebaseFirestore.instance.collection('Rides');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? newUser = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: hexStringToColor('#4364F7'),
          title: Text('Ride Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: rides.doc(newUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No ride found with your ID '));
          } else {
            final rideData = snapshot.data!.data() as Map<String, dynamic>;

            var usernames = rideData['user_username'];
            var userphones = rideData['user_phone'];
            var userfares = rideData['user_fares'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Source: ${rideData['Source']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      SizedBox(height: 16),
                      Text('Destination: ${rideData['Destination']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      SizedBox(height: 16),
                      Text('Time: ${rideData['Time']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      SizedBox(height: 16),
                      Text('Date: ${rideData['Date']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      SizedBox(height: 26),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            child: Text('End Ride'),
                            onPressed: () async {
                              await rides.doc(newUser.uid).update({
                                'RideStatus': 'completed',
                              }).then((value) async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context1) {
                                    return AlertDialog(
                                      title: Text('Ride Ended'),
                                      content: Text(
                                          'The ride has been marked as completed.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context1).pop();

                                            Fluttertoast.showToast(
                                                msg: "Ride has been completed");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                await backupTheCollection(
                                    rideData['id'], 'RidesBackup');
                              }).catchError((error) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context2) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'Failed to end the ride. Please try again.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context2).pop();
                                            Fluttertoast.showToast(
                                                msg: "Ride has been completed");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: hexStringToColor('#4364F7'),
                              onPrimary: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                  height: 1,
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                ),
                Expanded(
                  child: FutureBuilder(
                      future: rides.doc(newUser.uid).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error fetching ride details'));
                        }

                        if (usernames == null ||
                            usernames.isEmpty ||
                            userphones == null ||
                            userphones.isEmpty ||
                            userfares == null ||
                            userfares.isEmpty) {
                          return Container(
                            margin: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'Users are not available in this ride.',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.all(8),
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: [
                                GridTile(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 221, 219, 255),
                                    ),
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildNamePhoneAndFare(
                                            // 'User 1',
                                            usernames[0],
                                            userphones[0],
                                            userfares[0].toString(),
                                            Color.fromARGB(255, 221, 219, 255)),
                                        ElevatedButton(
                                          onPressed: () =>
                                              _makeCall(userphones[0]),
                                          child: Text('Call Now'),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                hexStringToColor('#4364F7'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GridTile(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 219, 239, 255),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildNamePhoneAndFare(
                                            // 'Driver (You)',
                                            rideData['username'],
                                            rideData['phone'],
                                            '',
                                            Color.fromARGB(255, 219, 239, 255)),
                                      ],
                                    ),
                                  ),
                                ),
                                GridTile(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 219, 219),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (usernames.length > 1 &&
                                              userphones.length > 1)
                                            Column(
                                              children: [
                                                _buildNamePhoneAndFare(
                                                  // 'User 2',
                                                  usernames[1],
                                                  userphones[1],
                                                  userfares[1].toString(),
                                                  Color.fromARGB(
                                                      255, 255, 219, 219),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => _makeCall(
                                                      userphones.length > 1
                                                          ? userphones[1]
                                                          : null),
                                                  child: Text('Call Now'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: hexStringToColor(
                                                        '#4364F7'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            Container(
                                              child: Text('Empty User Slot'),
                                            )
                                        ]),
                                  ),
                                ),
                                GridTile(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 219, 255, 242),
                                    ),
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (usernames.length > 2 &&
                                              userphones.length > 2)
                                            Column(
                                              children: [
                                                _buildNamePhoneAndFare(
                                                  // 'User 3',
                                                  usernames[2],
                                                  userphones[2],
                                                  userfares[2].toString(),
                                                  Color.fromARGB(
                                                      255, 219, 255, 242),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => _makeCall(
                                                      userphones.length > 2
                                                          ? userphones[2]
                                                          : null),
                                                  child: Text('Call Now'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: hexStringToColor(
                                                        '#4364F7'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            Container(
                                              child: Text('Empty User Slot'),
                                            )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

Widget _buildNamePhoneAndFare(
    // String label,
    String usernames,
    String userphones,
    String fare,
    Color parentcolor) {
  return Container(
    color: parentcolor,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(label,
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // SizedBox(height: 8),
          if (usernames == null ||
              usernames.isEmpty ||
              userphones == null ||
              userphones.isEmpty ||
              fare == null ||
              fare == 0.0)
            Text('Empty')
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(usernames,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(userphones,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('$fare',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    ),
  );
}
