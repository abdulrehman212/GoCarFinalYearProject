import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/assistants/request_assistant.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/key/map_key.dart';
import 'package:fyp_gocar/models/directions.dart';
import 'package:fyp_gocar/notificationservice/local_notification_services.dart';
import 'package:fyp_gocar/screen/OfferRide/offerride.dart';
import 'package:fyp_gocar/screen/predicted_places.dart';
import 'package:fyp_gocar/screen/userPoolScreen.dart';
import 'package:fyp_gocar/widgets/customdailog.dart';
import 'package:fyp_gocar/widgets/progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Ride.dart';
import '../utils/color_utils.dart';

class AvailableRides extends StatefulWidget {
  AvailableRides({super.key});

  @override
  State<AvailableRides> createState() => _AvailableRidesState();
}

class _AvailableRidesState extends State<AvailableRides> {
  LocalNotificationService localNotificationService =
      LocalNotificationService();

  bool loading = false;
  // List<Map<String, dynamic>> rideList = [];
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  String addressValueType = "";

  String? sourceName;
  String? destinationName;

  double distanceinkm = 0.0;
  bool isTap = false;

  double fare = 0.0;
  double user1fare = 0.0;
  double user2fare = 0.0;
  double user3fare = 0.0;

  List<PredictedPlaces> sourcePlacesPredictedList = [];
  List<PredictedPlaces> destinationPlacesPredictedList = [];

  Directions userPickUpLocation = Directions();
  Directions userDropOffLocation = Directions();

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) //2 or more than 2 input characters
    {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:PK";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          //placesPredictedList = placePredictionsList;
          if (addressValueType == "source") {
            sourcePlacesPredictedList = placePredictionsList;
          } else {
            destinationPlacesPredictedList = placePredictionsList;
          }
        });
      }
    }
  }

  getDestinationDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Expanded(
        child: Expanded(
          child: ProgressBar(
            message: "Please wait...",
          ),
        ),
      ),
    );

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occurred, Failed. No Response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      userDropOffLocation.locationName = responseApi["result"]["name"];
      destinationName = responseApi["result"]["name"];

      userDropOffLocation.locationId = placeId;
      userDropOffLocation.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      userDropOffLocation.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      //to check the results

      print("location name : " + userDropOffLocation.locationName!);
      print(
          "location lat : " + userDropOffLocation.locationLatitude!.toString());
      print("location long : " +
          userDropOffLocation.locationLongitude!.toString());

      Navigator.pop(context, "obtainedDetails");
    }
  }

  getSourceDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Expanded(
        child: Expanded(
          child: ProgressBar(
            message: "Please wait...",
          ),
        ),
      ),
    );

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occurred, Failed. No Response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      userPickUpLocation.locationName = responseApi["result"]["name"];
      sourceName = responseApi["result"]["name"];
      userPickUpLocation.locationId = placeId;
      userPickUpLocation.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      userPickUpLocation.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      //to check the results

      print("location name : " + userPickUpLocation.locationName!);
      print(
          "location lat : " + userPickUpLocation.locationLatitude!.toString());
      print("location long : " +
          userPickUpLocation.locationLongitude!.toString());

      Navigator.pop(context, "PickupLocationObtainedDetails");
    }
  }

  showbottomsheetforsource() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 60,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 10),
            child: Column(
              children: [
                //search place ui
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 235, 197, 254),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white54,
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                              ),
                            ),
                            const Center(
                              child: Text(
                                "Search Pickup Location",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.adjust_sharp,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (valueTyped) {
                                    findPlaceAutoCompleteSearch(valueTyped);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Search here...",
                                    fillColor: Colors.white54,
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 11.0,
                                      top: 8.0,
                                      bottom: 8.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),

                //display place predictions result
                (sourcePlacesPredictedList.length > 0)
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: sourcePlacesPredictedList.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                onTap: () async {
                                  getSourceDetails(
                                      sourcePlacesPredictedList[index].place_id,
                                      context);
                                  //   List<Location> locations = await locationFromAddress(_placesList[index]['description']);
                                  _sourceController.text =
                                      sourcePlacesPredictedList[index]
                                          .main_text!;
                                },
                                title: Text(
                                  sourcePlacesPredictedList[index].main_text!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            })),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }

  showbottomsheetfordestination() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 60,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              children: [
                //search place ui
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 162, 236, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white54,
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 25.0),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                              ),
                            ),
                            const Center(
                              child: Text(
                                "Search Drop off Location",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.adjust_sharp,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (valueTyped) {
                                    findPlaceAutoCompleteSearch(valueTyped);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Search here...",
                                    fillColor: Colors.white54,
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 11.0,
                                      top: 8.0,
                                      bottom: 8.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                //display place predictions result
                (destinationPlacesPredictedList.length > 0)
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: destinationPlacesPredictedList.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                onTap: () async {
                                  getDestinationDetails(
                                      destinationPlacesPredictedList[index]
                                          .place_id,
                                      context);
                                  //   List<Location> locations = await locationFromAddress(_placesList[index]['description']);
                                  _destinationController.text =
                                      destinationPlacesPredictedList[index]
                                          .main_text!;
                                },
                                title: Text(
                                  destinationPlacesPredictedList[index]
                                      .main_text!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            })),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }

  CollectionReference Rides = FirebaseFirestore.instance.collection('Rides');

  Future<double> calculateDistance(String origin, String destination) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$destination&key=$mapKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final rows = decodedData['rows'];

      if (rows.isNotEmpty) {
        final elements = rows[0]['elements'];

        if (elements.isNotEmpty) {
          final distance = elements[0]['distance'];
          final value = distance['value'];
          final distanceInKm = value / 1000.0; // Convert distance to kilometers

          print('Distance is: $distanceInKm');

          return distanceInKm;
        }
      }
    }

    return 0.0;
  }

  saveBookingandUpdateFare(
      int noOfSeats,
      String docId,
      List<String> uid,
      List<String> username,
      List<String> phone,
      List<String> email,
      List<double> fares,
      double distance) async {
    double basefare = 50.0;

    var documentRef = FirebaseFirestore.instance.collection('Rides').doc(docId);
    var snapshot = await documentRef.get();
    double user1distance;
    double user2distance;

    try {
      if (noOfSeats == 3) {
        user1fare = distance * basefare;
        setState(() {
          fare = user1fare;
        });

        await saveUserInfoAndCurrentFare(
            docId, uid, username, phone, email, [fare], [distance]);

        // await Rides.doc(docId).update({
        //   'user1fare': user1fare,
        //   'user1distance': distanceData,
        // });
        print('saveBookingandUpdateFare success 3 seat');
      }

      // ######################################################

      else if (noOfSeats == 2) {
        var max1;
        if (snapshot.exists) {
          var userDistanceArray = snapshot.get('user_kilometers');

          user1distance = userDistanceArray[0];

          // user1distance = snapshot.get('user1distance');
          if (user1distance > distance) {
            setState(() {
              max1 = user1distance;
            });
          } else {
            setState(() {
              max1 = distance;
            });
          }

          double value1 = max1 * basefare;
          double totalDistance = user1distance + distance;

          setState(() {
            user1fare = (user1distance / totalDistance) * value1;
            user2fare = (distance / totalDistance) * value1;
            fare = user2fare;
          });

          dynamic arrayData = snapshot.get('user_fares');

          if (arrayData is List && arrayData.isNotEmpty) {
            arrayData[0] = user1fare;

            await documentRef.update({'user_fares': arrayData});
          }

          await saveUserInfoAndCurrentFare(
              docId, uid, username, phone, email, [fare], [distance]);

          // documentRef.update({
          //   'user1fare': user1fare,
          //   'user2fare': user2fare,
          //   'user2distance': distanceData,
          // });
        }
        print('saveBookingandUpdateFare success 2 seat');
      }

      // #######################################################

      else if (noOfSeats == 1) {
        var max2;
        if (snapshot.exists) {
          var userDistanceArray1 = snapshot.get('user_kilometers');

          user1distance = userDistanceArray1[0];
          user2distance = userDistanceArray1[1];
          // user1distance = snapshot.get('user1distance');
          // user2distance = snapshot.get('user2distance');
          if (user2distance > user1distance && user2distance > distance) {
            setState(() {
              max2 = user2distance;
            });
          } else if (user1distance > user2distance &&
              user1distance > distance) {
            setState(() {
              max2 = user1distance;
            });
          } else {
            setState(() {
              max2 = distance;
            });
          }

          double value2 = max2 * basefare;
          double totalDistance = user1distance + user2distance + distance;

          setState(() {
            user1fare = (user1distance / totalDistance) * value2;
            user2fare = (user2distance / totalDistance) * value2;
            user3fare = (distance / totalDistance) * value2;
            fare = user3fare;
          });

          dynamic arrayData1 = snapshot.get('user_fares');

          if (arrayData1 is List && arrayData1.isNotEmpty) {
            arrayData1[0] = user1fare;
            arrayData1[1] = user2fare;

            await documentRef.update({'user_fares': arrayData1});
          }

          await saveUserInfoAndCurrentFare(
              docId, uid, username, phone, email, [fare], [distance]);

          // documentRef.update({
          //   'user1fare': user1fare,
          //   'user2fare': user2fare,
          //   'user3fare': user3fare,
          //   'user3distance': distanceData,
          // });
        }
        print('saveBookingandUpdateFare success 1 seat');
      }
      print('failed calculating fares ');
    } catch (e) {
      print('Error occured in fare calculation  $e');
    }
  }

  Future<String> saveUserInfoAndCurrentFare(
    String rideId,
    List<String> uid,
    List<String> username,
    List<String> phone,
    List<String> email,
    List<double> fares,
    List<double> kilometers,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Rides')
          .where('id', isEqualTo: uid)
          .get();

      if (snapshot.docs.isEmpty) {
        CollectionReference rides =
            FirebaseFirestore.instance.collection('Rides');

        await rides.doc(rideId).update({
          'user_uid': FieldValue.arrayUnion(uid),
          'user_username': FieldValue.arrayUnion(username),
          'user_phone': FieldValue.arrayUnion(phone),
          'user_email': FieldValue.arrayUnion(email),
          'user_fares': FieldValue.arrayUnion(fares),
          'user_kilometers': FieldValue.arrayUnion(kilometers),
        });
        print('saveUserInfoAndCurrentFare');
        return 'success';
      } else {
        print('save booking info failed! ');

        return 'failed';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> getandupdatedSeats(String rideId) async {
    try {
      CollectionReference ridesCollection =
          FirebaseFirestore.instance.collection('Rides');
      final snapshot = await ridesCollection.doc(rideId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      int updateSeats = data['NumberOfSeatsAvailable'] - 1;

      await ridesCollection
          .doc(rideId)
          .update({'NumberOfSeatsAvailable': updateSeats});
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  Future<List<String>?> getUserInfoArray(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? UserType;
      UserType = await prefs.getString('userType');

      String collectionName = UserType == 'user' ? 'usersData' : 'DriverData';

      CollectionReference currentusers =
          FirebaseFirestore.instance.collection(collectionName);
      final snapshot =
          await currentusers.where('email', isEqualTo: email).get();
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final username = data['username'] as String?;
      final phone = data['phone'] as String?;
      final saveEmail = data['email'] as String?;

      return [username ?? "", phone ?? "", saveEmail ?? ""];
    } catch (e) {
      return null;
    }
  }

/*
  Future<List<double>?> getFareDistanceArray(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? UserType;
      UserType = await prefs.getString('userType');

      String collectionName = UserType == 'user' ? 'usersData' : 'DriverData';

      CollectionReference currentusers =
          FirebaseFirestore.instance.collection(collectionName);
      final snapshot =
          await currentusers.where('email', isEqualTo: email).get();
      final data = snapshot.docs.first.data() as Map<double, dynamic>;
      final getDistance = data['username'] as double?;
      final getfare = data['phone'] as double?;
      print(getDistance);
      print(getfare);

      return [getDistance ?? 0.0, getfare ?? 0.0];
    } catch (e) {
      return null;
    }
  }
*/

  Future<List<Map<String, dynamic>>> getData() async {
    List<Map<String, dynamic>> dataList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Rides').get();

    querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id; // add document id to data map
      dataList.add(data);
    }).toList();

    print(dataList);

    return dataList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sourceController = TextEditingController();
    _destinationController = TextEditingController();

    // printRoute();

    localNotificationService.requestNotificationPermissions();
    // localNotificationService.isTokenRefresh();
    // localNotificationService.getDeviceToken();

    localNotificationService.initializeBackground(context);

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: hexStringToColor('#4364F7'),
          title: const Center(child: Text('Available Rides')),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? newUser = auth.currentUser;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            } else {
              List<Map<String, dynamic>> rideList = snapshot.data!;

              rideList = rideList
                  .where((ride) =>
                      ride['NumberOfSeatsAvailable'] > 0 &&
                      ride['RideStatus'] == 'inprogress')
                  .toList();

              // #####################################################

              // allRide = snapshot.data!;
              // searchPooledRides(mapKey, widget.searchedSource,
              //     widget.searchedDestination, allRide);

              // #########################################################

              if (rideList.isEmpty) {
                return Center(
                  child: Text('No available rides found'),
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: rideList.length,
                    itemBuilder: ((context, index) {
                      return SizedBox(
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          shadowColor: Colors.grey,
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Color.fromARGB(66, 4, 0, 0),
                              //color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          //this rounded rectengle is for, curve karne ke liye ye use kara hai hora

                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/carstock.png',
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(rideList[index]['username'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(rideList[index]['phone'],
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: const [
                                          Text("Seats",
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.airline_seat_recline_extra,
                                              color:
                                                  hexStringToColor('#4364F7'),
                                              size: 40,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Text(
                                                rideList[index][
                                                        'NumberOfSeatsAvailable']
                                                    .toString(),
                                                style: TextStyle(fontSize: 20)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey.withOpacity(0.5),
                                height: 1,
                                thickness: 2,
                                indent: 5,
                                endIndent: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_sharp,
                                              color:
                                                  hexStringToColor('#4364F7'),
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Source",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text(
                                                      rideList[index]['Source'],
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 7.5),
                                          child: DottedLine(
                                            direction: Axis.vertical,
                                            lineLength: 35,
                                            dashColor: Colors.black54,
                                            dashGapLength: 5,
                                            dashLength: 4,
                                            dashRadius: 10,
                                            lineThickness: 3,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Destination",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text(
                                                      rideList[index]
                                                          ['Destination'],
                                                      maxLines: null,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Date",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(rideList[index]['Date'],
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ]),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Time",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          rideList[index]
                                                              ['Time'],
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                var userInfo =
                                                    await getUserInfoArray(
                                                        newUser!.email!);
                                                // var userDistanceAndFare =
                                                //     await getFareDistanceArray(
                                                //         newUser.email!);

                                                var username = userInfo![0];
                                                var phone = userInfo[1];
                                                var email = userInfo[2];
                                                // var Kdistance =
                                                //     userDistanceAndFare![0];
                                                // final Kfare =
                                                //     userDistanceAndFare[1];

                                                var noOfSEAT = rideList[index]
                                                    ['NumberOfSeatsAvailable'];

                                                List<dynamic> passengers =
                                                    rideList[index]
                                                            ['user_email'] ??
                                                        [];

                                                if (rideList[index]['email'] ==
                                                    newUser.email) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                        context11) {
                                                      return AlertDialog(
                                                        title: Text('Failed!'),
                                                        content: Text(
                                                            'Sorry! A driver cannot book his own ride.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context11)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  if (noOfSEAT < 1) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context11) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Failed!'),
                                                          content: Text(
                                                              'No Seats available in this ride'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context11)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if (passengers
                                                      .contains(
                                                          newUser.email)) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context11) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Failed!'),
                                                          content: Text(
                                                              'user already booked'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context11)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    _showModalBottomSheet(
                                                        context,
                                                        rideList[index][
                                                            'NumberOfSeatsAvailable'],
                                                        rideList[index]['id'],
                                                        [newUser.uid],
                                                        [username],
                                                        [phone],
                                                        [email],
                                                        [fare],
                                                        distanceinkm,
                                                        rideList[index]
                                                            ['drivertoken']);

                                                    // yaha per bttom sheet k bad

                                                    // showDialog(
                                                    //   context: context,
                                                    //   builder: (BuildContext
                                                    //           context) =>
                                                    //       Expanded(
                                                    //     child: Expanded(
                                                    //       child: ProgressBar(
                                                    //         message:
                                                    //             "Please wait...",
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // );

                                                    // Navigator.pop(context);
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                "Book now",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
/*
                      // Container(
                      //   child: Column(children: [
                      //     Text(rideList[index]['id']),
                      //     Text(rideList[index]['Date']),
                      //     Text(rideList[index]['Time']),
                      //     Text(rideList[index]['Source']),
                      //     Text(rideList[index]['Destination']),
                      //     Text(rideList[index]['username']),
                      //     ElevatedButton(onPressed: (){

                      //       if(getandupdatedSeats(rideList[index]['id'],'NumberOfSeatsAvailable') == 'success'){
                      //         showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             title: Text('Congratulation!'),
                      //             content: Text('You have booked a ride successfully.'),
                      //             actions: [
                      //               TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: Text('OK'),
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );

                      //       }else if(getandupdatedSeats(rideList[index]['id'],'NumberOfSeatsAvailable') == 'failed'){
                      //         showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             title: Text('Failed! '),
                      //             content: Text('No seats available in this ride.'),
                      //             actions: [
                      //               TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: Text('OK'),
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );

                      //       }else{
                      //         showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             title: Text('Error! '),
                      //             content: Text('An error occured. Please try again.'),
                      //             actions: [
                      //               TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: Text('OK'),
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );

                      //       }
                      //     }, child: Text('BOOK NOW'))
                      //   ],),
                      //  );
                      */
                    }),
                  ),
                );
              }
            }
          },
        ));
  }

  void _showModalBottomSheet(
      BuildContext context,
      int noOfSeats,
      String docId,
      List<String> uid,
      List<String> username,
      List<String> phone,
      List<String> email,
      List<double> fares,
      double distance,
      String token) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 179, 221, 255),
                Color.fromARGB(255, 248, 212, 255)
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Please enter the following details.',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'From',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your source location',
                ),
                controller: _sourceController,
                onTap: () {
                  setState(() {
                    addressValueType = "source";
                  });
                  showbottomsheetforsource();
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'To',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your destination location',
                ),
                controller: _destinationController,
                onTap: () {
                  setState(() {
                    addressValueType = "destination";
                  });
                  showbottomsheetfordestination();
                },
              ),
              SizedBox(height: 26.0),
              ElevatedButton(
                onPressed: () async {
                  String source = _sourceController.text.trim();
                  String destination = _destinationController.text.trim();

                  print('Source >>>>>>     $source');
                  print('Source >>>>>>     $destination');

                  if (source.isNotEmpty && destination.isNotEmpty) {
                    String src = _sourceController.text;
                    String dest = _destinationController.text;

                    setState(() {
                      distanceinkm =
                          0.0; // Reset distanceinkm to 0 before making the API call
                    });

                    double distance = await calculateDistance(src, dest);

                    setState(() {
                      distanceinkm =
                          distance; // Update distanceinkm with the calculated distance
                    });
                    print(
                        'Distance            >>>>>>>>>>>>>>>>>>>>>>         : ');
                    print(distanceinkm);

                    if (distanceinkm != 0.0) {
                      await saveBookingandUpdateFare(noOfSeats, docId, uid,
                          username, phone, email, fares, distanceinkm);

                      String respn = await getandupdatedSeats(docId);
                      if (respn == 'success') {
                        // show dailog success
                        print(
                            '###############         succes and completed                 #############');
                        await localNotificationService.sendNotificationToDevice(
                            '/Message_Screen', token);
                      } else {
                        // show dailog failed
                        print(
                            '###############         failed and completed                 #############');
                      }
                    }

                    // ye bool jo ap ne bola tha isloading kar k
//
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context11) {
                    //     return
                    //         // buildCustomDailog(
                    //         //   context11,
                    //         //   'Congratulation! , You have booked a ride Succesfully',
                    //         //   'Your fare is : $fare  , It will reduce if a new user book this ride.',
                    //         // );

                    //         AlertDialog(
                    //       title: const Text(
                    //           'Congratulation! , You have booked a ride Succesfully'),
                    //       content: Text(
                    //           'Currently, your fare is : $fare  '),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () async {
                    //             Navigator.of(context11).pop();
                    //           },
                    //           child: const Text('OK'),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Incomplete Fields'),
                          content:
                              Text('Please enter both source and destination.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
