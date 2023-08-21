// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import '../../utils/color_utils.dart';
// import '../../widgets/reusable_widget.dart';

// class BookRide extends StatefulWidget {
//   const BookRide({super.key});

//   @override
//   State<BookRide> createState() => _BookRideState();
// }

// TextEditingController _SearchSourceTextController = TextEditingController();
// TextEditingController _SearchDestinationTextController =
//     TextEditingController();

// class _BookRideState extends State<BookRide> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Book Ride"),
//         elevation: 1,
//         backgroundColor: hexStringToColor('#4364F7'),
//       ),
//       backgroundColor: Color.fromARGB(255, 252, 245, 245),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 12,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: const Text(
//               "Enter Location Details",
//               style: TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 17,
//                   fontStyle: FontStyle.italic),
//               textAlign: TextAlign.left,
//             ),
//           ),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//               child: resuableTextField(
//                   " Source Location",
//                   Icons.location_on_rounded,
//                   false,
//                   _SearchSourceTextController),
//             ),
//           ),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//               child: resuableTextField(
//                   " Destination Location",
//                   Icons.location_on_rounded,
//                   false,
//                   _SearchDestinationTextController),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           ElevatedButton.icon(
//             icon: Icon(Icons.search_rounded),
//             label: Text("Search rides"),
//             onPressed: () {
//               (Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const BookRide())));
//               // Perform some action when the button is pressed
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.pressed)) {
//                   return Colors.blueGrey;
//                 }
//                 return hexStringToColor('#4364F7');
//               }),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30))),
//               elevation: MaterialStateProperty.all(8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
