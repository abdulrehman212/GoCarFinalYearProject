// import 'package:flutter/material.dart';
// import 'package:fyp_gocar/assistants/request_assistant.dart';
// import 'package:fyp_gocar/key/map_key.dart';
// import 'package:fyp_gocar/models/directions.dart';
// import 'package:fyp_gocar/screen/UsersSreen/fareCalculation.dart';
// import 'package:fyp_gocar/screen/availableRides.dart';
// import 'package:fyp_gocar/screen/predicted_places.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../widgets/progress_bar.dart';

// class PoolScreen extends StatefulWidget {
//   String rideId;
//   PoolScreen({
//     Key? key,
//     required this.rideId,
//   }) : super(key: key);

//   @override
//   _PoolScreenState createState() => _PoolScreenState();
// }

// class _PoolScreenState extends State<PoolScreen> {
//   TextEditingController _sourceController = TextEditingController();
//   TextEditingController _destinationController = TextEditingController();

//   String addressValueType = "";
//   String? sourceName;
//   String? destinationName;

//   List<PredictedPlaces> sourcePlacesPredictedList = [];
//   List<PredictedPlaces> destinationPlacesPredictedList = [];

//   Directions userPickUpLocation = Directions();
//   Directions userDropOffLocation = Directions();

//   void findPlaceAutoCompleteSearch(String inputText) async {
//     if (inputText.length > 1) //2 or more than 2 input characters
//     {
//       String urlAutoCompleteSearch =
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:PK";

//       var responseAutoCompleteSearch =
//           await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

//       if (responseAutoCompleteSearch ==
//           "Error Occurred, Failed. No Response.") {
//         return;
//       }

//       if (responseAutoCompleteSearch["status"] == "OK") {
//         var placePredictions = responseAutoCompleteSearch["predictions"];

//         var placePredictionsList = (placePredictions as List)
//             .map((jsonData) => PredictedPlaces.fromJson(jsonData))
//             .toList();

//         setState(() {
//           //placesPredictedList = placePredictionsList;
//           if (addressValueType == "source") {
//             sourcePlacesPredictedList = placePredictionsList;
//           } else {
//             destinationPlacesPredictedList = placePredictionsList;
//           }
//         });
//       }
//     }
//   }

//   getDestinationDetails(String? placeId, context) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => Expanded(
//         child: Expanded(
//           child: ProgressBar(
//             message: "Please wait...",
//           ),
//         ),
//       ),
//     );

//     String placeDirectionDetailsUrl =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
//     var responseApi =
//         await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

//     Navigator.pop(context);

//     if (responseApi == "Error Occurred, Failed. No Response.") {
//       return;
//     }

//     if (responseApi["status"] == "OK") {
//       userDropOffLocation.locationName = responseApi["result"]["name"];
//       destinationName = responseApi["result"]["name"];

//       userDropOffLocation.locationId = placeId;
//       userDropOffLocation.locationLatitude =
//           responseApi["result"]["geometry"]["location"]["lat"];
//       userDropOffLocation.locationLongitude =
//           responseApi["result"]["geometry"]["location"]["lng"];

//       // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
//       //to check the results

//       print("location name : " + userDropOffLocation.locationName!);
//       print(
//           "location lat : " + userDropOffLocation.locationLatitude!.toString());
//       print("location long : " +
//           userDropOffLocation.locationLongitude!.toString());

//       Navigator.pop(context, "obtainedDetails");
//     }
//   }

//   getSourceDetails(String? placeId, context) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => Expanded(
//         child: Expanded(
//           child: ProgressBar(
//             message: "Please wait...",
//           ),
//         ),
//       ),
//     );

//     String placeDirectionDetailsUrl =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
//     var responseApi =
//         await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

//     Navigator.pop(context);

//     if (responseApi == "Error Occurred, Failed. No Response.") {
//       return;
//     }

//     if (responseApi["status"] == "OK") {
//       userPickUpLocation.locationName = responseApi["result"]["name"];
//       sourceName = responseApi["result"]["name"];
//       userPickUpLocation.locationId = placeId;
//       userPickUpLocation.locationLatitude =
//           responseApi["result"]["geometry"]["location"]["lat"];
//       userPickUpLocation.locationLongitude =
//           responseApi["result"]["geometry"]["location"]["lng"];

//       // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
//       //to check the results

//       print("location name : " + userPickUpLocation.locationName!);
//       print(
//           "location lat : " + userPickUpLocation.locationLatitude!.toString());
//       print("location long : " +
//           userPickUpLocation.locationLongitude!.toString());

//       Navigator.pop(context, "PickupLocationObtainedDetails");
//     }
//   }

//   showbottomsheetforsource() async {
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 top: 60,
//                 left: 20,
//                 right: 20,
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom + 10),
//             child: Column(
//               children: [
//                 //search place ui
//                 Container(
//                   height: 160,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 235, 197, 254),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white54,
//                         blurRadius: 8,
//                         spreadRadius: 0.5,
//                         offset: Offset(
//                           0.7,
//                           0.7,
//                         ),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 15.0),
//                         Stack(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const Center(
//                               child: Text(
//                                 "Search Pickup Location",
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10.0),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.adjust_sharp,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(
//                               width: 15.0,
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextField(
//                                   onChanged: (valueTyped) {
//                                     findPlaceAutoCompleteSearch(valueTyped);
//                                   },
//                                   decoration: const InputDecoration(
//                                     hintText: "Search here...",
//                                     fillColor: Colors.white54,
//                                     filled: true,
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                       left: 11.0,
//                                       top: 8.0,
//                                       bottom: 8.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10.0),
//                       ],
//                     ),
//                   ),
//                 ),

//                 //display place predictions result
//                 (sourcePlacesPredictedList.length > 0)
//                     ? Expanded(
//                         child: ListView.builder(
//                             itemCount: sourcePlacesPredictedList.length,
//                             itemBuilder: ((context, index) {
//                               return ListTile(
//                                 onTap: () async {
//                                   getSourceDetails(
//                                       sourcePlacesPredictedList[index].place_id,
//                                       context);
//                                   //   List<Location> locations = await locationFromAddress(_placesList[index]['description']);
//                                   _sourceController.text =
//                                       sourcePlacesPredictedList[index]
//                                           .main_text!;
//                                 },
//                                 title: Text(
//                                   sourcePlacesPredictedList[index].main_text!,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               );
//                             })),
//                       )
//                     : Container(),
//               ],
//             ),
//           );
//         });
//   }

//   showbottomsheetfordestination() async {
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 top: 60,
//                 left: 20,
//                 right: 20,
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//             child: Column(
//               children: [
//                 //search place ui
//                 Container(
//                   height: 160,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 162, 236, 255),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white54,
//                         blurRadius: 8,
//                         spreadRadius: 0.5,
//                         offset: Offset(
//                           0.7,
//                           0.7,
//                         ),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 25.0),
//                         Stack(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const Center(
//                               child: Text(
//                                 "Search Drop off Location",
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16.0),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.adjust_sharp,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(
//                               width: 15.0,
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextField(
//                                   onChanged: (valueTyped) {
//                                     findPlaceAutoCompleteSearch(valueTyped);
//                                   },
//                                   decoration: const InputDecoration(
//                                     hintText: "Search here...",
//                                     fillColor: Colors.white54,
//                                     filled: true,
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                       left: 11.0,
//                                       top: 8.0,
//                                       bottom: 8.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 //display place predictions result
//                 (destinationPlacesPredictedList.length > 0)
//                     ? Expanded(
//                         child: ListView.builder(
//                             itemCount: destinationPlacesPredictedList.length,
//                             itemBuilder: ((context, index) {
//                               return ListTile(
//                                 onTap: () async {
//                                   getDestinationDetails(
//                                       destinationPlacesPredictedList[index]
//                                           .place_id,
//                                       context);
//                                   //   List<Location> locations = await locationFromAddress(_placesList[index]['description']);
//                                   _destinationController.text =
//                                       destinationPlacesPredictedList[index]
//                                           .main_text!;
//                                 },
//                                 title: Text(
//                                   destinationPlacesPredictedList[index]
//                                       .main_text!,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               );
//                             })),
//                       )
//                     : Container(),
//               ],
//             ),
//           );
//         });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _sourceController = TextEditingController();
//     _destinationController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _sourceController.dispose();
//     _destinationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Confirm pool'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color.fromARGB(255, 179, 221, 255),
//               Color.fromARGB(255, 242, 187, 252)
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.5),
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Enter your pickup location',
//                   style: TextStyle(
//                     fontSize: 20, // Adjust the font size as desired
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 TextField(
//                   controller: _sourceController,
//                   onTap: () {
//                     setState(() {
//                       addressValueType = "source";
//                     });
//                     showbottomsheetforsource();
//                   },
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.8),
//                     labelText: 'From',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 26),
//                 Text(
//                   'Enter your dropoff location',
//                   style: TextStyle(
//                     fontSize: 20, // Adjust the font size as desired
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 TextField(
//                   controller: _destinationController,
//                   onTap: () {
//                     setState(() {
//                       addressValueType = "destination";
//                     });
//                     showbottomsheetfordestination();
//                   },
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.8),
//                     labelText: 'To',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: () {
//                     String source = _sourceController.text;
//                     String destination = _destinationController.text;

//                     print('Source >>>>>>     $source');
//                     print('Source >>>>>>     $destination');

//                     if (source.isNotEmpty && destination.isNotEmpty) {
//                       //now go to fare screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => fare_Calculation(
//                             rideDocId: widget.rideId,
//                             source: sourceName!,
//                             destination: destinationName!,
//                           ),
//                         ),
//                       );
//                     } else {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('Incomplete Fields'),
//                             content: Text(
//                                 'Please enter both source and destination.'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                   },
//                   child: Text('Confirm'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
