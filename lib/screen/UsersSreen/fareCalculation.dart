// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fyp_gocar/key/map_key.dart';
// import 'package:fyp_gocar/widgets/customdailog.dart';
// import 'package:fyp_gocar/widgets/progress_bar.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class fare_Calculation extends StatefulWidget {
//   String source;
//   String destination;
//   String rideDocId;

//   fare_Calculation({
//     Key? key,
//     required this.rideDocId,
//     required this.source,
//     required this.destination,
//   }) : super(key: key);

//   @override
//   State<fare_Calculation> createState() => _fare_CalculationState();
// }

// class _fare_CalculationState extends State<fare_Calculation> {
//   double distanceData = 0.0;

//   Future<void> calculateDistance(String origin, String destination) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$destination&key=$mapKey');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final decodedData = json.decode(response.body);
//       final rows = decodedData['rows'];

//       if (rows.isNotEmpty) {
//         final elements = rows[0]['elements'];

//         if (elements.isNotEmpty) {
//           final distance = elements[0]['distance'];
//           final value = distance['value'];
//           final distanceInKm = value / 1000.0; // Convert distance to kilometers
//           setState(() {
//             distanceData = distanceInKm;
//           });
//         }
//       }
//     }
//   }

//   // Future<void> calculateAndUpdateFares(
//   //     Map<String, double> userDistances, double baseFare, String docId) async {

//   //   CollectionReference ridesCollection =
//   //       FirebaseFirestore.instance.collection('Rides');
//   //   // Find the maximum distance among all users
//   //   double maxDistance = userDistances.values
//   //       .reduce((max, distance) => distance > max ? distance : max);

//   //   // Get all the users' document references in Firestore
//   //   final snapshot =
//   //       await FirebaseFirestore.instance.collection('Rides').doc(docId).get();

//   //   final data = snapshot.data() as Map<String, dynamic>;

//   //   for (DocumentSnapshot userSnapshot in usersSnapshot.docs) {
//   //     String userId = userSnapshot.id;
//   //     Map<String, dynamic> userData =
//   //         userSnapshot.data() as Map<String, dynamic>;

//   //     // Get the user's distance
//   //     double userDistance = userDistances[userId] ?? 0;

//   //     // Calculate the fare based on the user's distance and base fare
//   //     double fare = userDistance == maxDistance
//   //         ? userDistance * baseFare
//   //         : (userDistance / maxDistance) * baseFare;

//   //     // Update the fare in the user's document
//   //     userData['fare'] = fare;
//   //     await usersRef.doc(userId).update(userData);
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fare Screen'),
//       ),
//       body: Container(
//         child: Center(
//           child: Column(
//             children: [
//               ElevatedButton(
//                   onPressed: () async {
//                     // showDialog(
//                     //     context: context,
//                     //     builder: (BuildContext context) =>
//                     //         buildCustomDailog(context));
//                     // // showDialog(
//                     //   context: context,
//                     //   builder: (BuildContext context) => Expanded(
//                     //     child: Expanded(
//                     //       child: ProgressBar(
//                     //         message: "Please wait...",
//                     //       ),
//                     //     ),
//                     //   ),
//                     // );
//                     await calculateDistance(widget.source, widget.destination);
//                     // Navigator.pop(context);
//                   },
//                   child: Text('Calculate Distance')),
//               SizedBox(
//                 height: 30,
//               ),
//               Text('Your distance is :     \' $distanceData \'    Kilometer'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
