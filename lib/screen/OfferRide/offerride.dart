import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_gocar/assistants/assistant_methods.dart';
import 'package:fyp_gocar/assistants/request_assistant.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/key/map_key.dart';
import 'package:fyp_gocar/models/directions.dart';
import 'package:fyp_gocar/screen/predicted_places.dart';
import 'package:fyp_gocar/tabpages/home_tabpage.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:fyp_gocar/widgets/progress_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../main_screen.dart';

class OfferRide extends StatefulWidget {
  const OfferRide({super.key});

  @override
  State<OfferRide> createState() => _OfferRideState();
}

TextEditingController _sourceTextController = TextEditingController();
TextEditingController _destinationTextController = TextEditingController();
TextEditingController _dateController = TextEditingController();
TextEditingController _timeController = TextEditingController();

String? Source;
String? Destination;
String? Date;
String? Time;

String driverName = '';
String driverPhone = '';
String driverEmail = '';

String addressValueType = "";

Directions pickUpLocation = Directions();
Directions dropOffLocation = Directions();

LatLng latLngPosition = LatLng(0.0, 0.0); //user current location
LatLng sourceLatLng = LatLng(0.0, 0.0);
LatLng destinationLatLng = LatLng(0.0, 0.0);

DateTime? selectedDate;

class _OfferRideState extends State<OfferRide> {
  // final DataController db_controller = Get.find();

  final CollectionReference driverRides = FirebaseFirestore.instance
      .collection('DriverData')
      .doc(user.uid)
      .collection("rides");

  // final CollectionReference _rides =
  // FirebaseFirestore.instance.collection('Rides');

  PredictedPlaces? sourcePredictedPlaces;
  List<PredictedPlaces> sourcePlacesPredictedList = [];
  List<PredictedPlaces> destinationPlacesPredictedList = [];

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? newgoogleMapController;

  double searchLocationContainerHeight = 353;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  String humanReadableAddress = "";

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  Set<Marker> _markers = Set<Marker>();

  // final LatLng _markerLocation = LatLng(37.422, -122.084);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

/*
  _moveCameraToFitBounds(LatLngBounds(
      southwest: sourceLatLng,
      northeast: destinationLatLng,
    ));

     void _moveCameraToFitBounds(LatLngBounds bounds) {
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _controller.animateCamera(cameraUpdate);
  }
*/
  blackthemegooglemap() {
    newgoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    setState(() {
      latLngPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
      pickUpLocation.locationLatitude = userCurrentPosition!.latitude;
      pickUpLocation.locationLongitude = userCurrentPosition!.longitude;
      sourceLatLng = latLngPosition;
    });

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    newgoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            pickUpLocation, userCurrentPosition!, context);

    print("this is your address = " + humanReadableAddress);
  }

  checkIfLocationPermissionAllowed() async {
    // user ki permission lega device location on karne k liye
    try {
      _locationPermission = await Geolocator.requestPermission();

      if (_locationPermission == LocationPermission.denied) {
        _locationPermission = await Geolocator.requestPermission();
      }
    } catch (e) {
      print(e);
    }
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  Future<void> myDatePicker(BuildContext context) async {
    DateTime? datepicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 2)));

    if (datepicked != null && datepicked != selectedDate) {
      setState(() {
        selectedDate = datepicked;
        _dateController.text = datepicked.toString();
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  Future<void> myTimePicker(BuildContext context) async {
    // 24 hour
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (pickedTime != null) {
      _timeController.text = pickedTime.toString().substring(10, 15);
    }
  }

  void findPlaceAutoCompleteSearch(String inputText) async {
    //  address input then suggestions return hoti
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
    final customicon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(0.5, 0.5)),
      'assets/flag.png',
    );
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
      dropOffLocation.locationName = responseApi["result"]["name"];
      dropOffLocation.locationId = placeId;
      dropOffLocation.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      dropOffLocation.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      setState(() {
        destinationLatLng = LatLng(dropOffLocation.locationLatitude!,
            dropOffLocation.locationLongitude!);
        _markers.add(Marker(
          markerId: MarkerId("DestinationMarker1"),
          infoWindow: InfoWindow(
            title: 'Destination : ${dropOffLocation.locationName}',
          ),
          position: destinationLatLng,
          //  icon: customicon
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ));

        CameraPosition cameraPosition =
            CameraPosition(target: destinationLatLng, zoom: 16);
        newgoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        /*      
      LatLngBounds bounds = LatLngBounds(
        southwest: sourceLatLng,
        northeast: destinationLatLng
      );
   
      newgoogleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0),
      );
*/
      });

      // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      //to check the results

      print("location name : " + dropOffLocation.locationName!);
      print("location lat : " + dropOffLocation.locationLatitude!.toString());
      print("location long : " + dropOffLocation.locationLongitude!.toString());

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
      pickUpLocation.locationName = responseApi["result"]["name"];
      pickUpLocation.locationId = placeId;
      pickUpLocation.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      pickUpLocation.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      setState(() {
        sourceLatLng = LatLng(pickUpLocation.locationLatitude!,
            pickUpLocation.locationLongitude!);
        _markers.add(Marker(
          markerId: MarkerId("SourceMarker1"),
          infoWindow: InfoWindow(
            title: 'Source : ${pickUpLocation.locationName}',
          ),
          position: sourceLatLng,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        ));

        CameraPosition cameraPosition =
            CameraPosition(target: sourceLatLng, zoom: 16);

        newgoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });

      // Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
      //to check the results

      print("location name : " + pickUpLocation.locationName!);
      print("location lat : " + pickUpLocation.locationLatitude!.toString());
      print("location long : " + pickUpLocation.locationLongitude!.toString());

      Navigator.pop(context, "PickupLocationObtainedDetails");
    }
  }

  showbottomsheetforsource() async {
    await showModalBottomSheet(
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
                    color: Color.fromARGB(255, 221, 152, 255),
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
                                "Search & Set Pickup Location",
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
                                    hintText: "search here...",
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
                        GestureDetector(
                          onTap: () {
                            locateUserPosition();
                            setState(() {
                              _sourceTextController.text = humanReadableAddress;
                            });
                            _markers.add(Marker(
                              markerId: MarkerId("SourceMarker1"),
                              infoWindow: InfoWindow(
                                title:
                                    'Source : ${pickUpLocation.locationName}',
                              ),
                              position: sourceLatLng,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueYellow),
                            ));
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.my_location,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: const Text(
                                  "Your Current Location",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                  _sourceTextController.text =
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
                    color: Colors.blue,
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
                                "Search & Set Drop off Location",
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
                                  _destinationTextController.text =
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

  Future<String?> getUserDocID(String email) async {
    try {
      String? myId;
      await FirebaseFirestore.instance
          .collection('DriverData')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        myId = value.docs.first.id;
      });
      return myId;
    } catch (e) {
      return 'Error fetching user';
    }
  }

  checkUserDoc(String email, String rideId) async {
    final firebaseInstance = FirebaseFirestore.instance;
    try {
      final snapshot = await firebaseInstance
          .collection('Rides')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        await firebaseInstance.collection('Rides').doc(rideId).set({
          "id ": rideId,
          "username": driverName,
          "phone": driverPhone,
          "email ": driverEmail,
          "Source": Source,
          "Destination": Destination,
          "Date": Date,
          "Time": Time,
          "RideStatus": rideStatus,
          "NumberOfSeatsAvailable": numberOfSeatAvailable
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeTabPage()));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cannot offer ride'),
              content: Text('You have already offered a ride'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<void> checkAndCreateDocument(String rideId) async {
    try {
      CollectionReference ridesCollection =
          FirebaseFirestore.instance.collection('Rides');
      DocumentSnapshot snapshot = await ridesCollection.doc(rideId).get();

      if (snapshot.exists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cannot offer ride'),
              content: Text('You have already offered a ride'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        await ridesCollection.doc(rideId).set({
          "id": rideId,
          "username": driverName,
          "phone": driverPhone,
          "email": driverEmail,
          "Source": Source,
          "Destination": Destination,
          "Date": Date,
          "Time": Time,
          "RideStatus": rideStatus,
          "NumberOfSeatsAvailable": numberOfSeatAvailable
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Congratulation'),
              content: Text('You have created a ride'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, animationTime) {
                          return MainScreen();
                        },
                      ),
                      (route) => false,
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        // ignore: use_build_context_synchronously
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> getUserInfo(String USERID, String KEY) async {
    try {
      CollectionReference currentusers =
          FirebaseFirestore.instance.collection('DriverData');
      final snapshot = await currentusers.doc(USERID).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data[KEY];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowed();
    _sourceTextController.addListener(() {
      // onChange();
    });
    _destinationTextController.addListener(() {
      // onChange();
    });

    //  setState(() {
    //    driverName = '${db_controller.userProfileData['username']}';
    //    driverPhone = '${db_controller.userProfileData['phone']}';
    //  });
    // BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(size: Size(48, 48)),
    //   'assets/flag.png',
    // ).then((value) => _markerIcon = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Offer Ride"),
          elevation: 1,
          backgroundColor: hexStringToColor('#4364F7'),
        ),
        backgroundColor: Color.fromARGB(255, 252, 245, 245),
        body: Stack(
          children: [
            GoogleMap(
              markers: _markers,
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newgoogleMapController = controller;
                //for black theme
                blackthemegooglemap();

                setState(() {
                  bottomPaddingOfMap = 340;
                });

                locateUserPosition();
              },
            ),
            Positioned(
                bottom: 0,
                left: 5,
                right: 5,
                child: Container(
                  padding: new EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(212, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),

                      //Source

                      TextFormField(
                        cursorColor: hexStringToColor('#4364F7'),
                        controller: _sourceTextController,
                        onTap: () async {
                          setState(() {
                            addressValueType = "source";
                          });
                          showbottomsheetforsource();

/*
                              _markers.add(
                                Marker(
                                  markerId: MarkerId('Marker1'),
                                  position: LatLng(SourceLat, SourceLng),
                                  ),
                                  );
                                  CameraPosition cameraPosition =
                                  CameraPosition(target: latLngPosition, zoom: 16);
                                  newgoogleMapController!
                                  .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));   
  */
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          labelText: 'Source',
                          labelStyle:
                              TextStyle(color: hexStringToColor('#4364F7')),
                          suffixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),

                      SizedBox(height: 10),
                      //destination
                      TextFormField(
                        cursorColor: hexStringToColor('#4364F7'),
                        controller: _destinationTextController,
                        onTap: () async {
                          setState(() {
                            addressValueType = "destination";
                          });
                          showbottomsheetfordestination();

/*
                             _markers.add(
                              Marker(
                                markerId: MarkerId('Marker2'),
                                position: LatLng(DestinationLat, DestinationLng),
                                ),
                                );
                                
  */
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          labelText: 'Destination',
                          labelStyle:
                              TextStyle(color: hexStringToColor('#4364F7')),
                          suffixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        cursorColor: hexStringToColor('#4364F7'),
                        controller: _dateController,
                        onTap: () => myDatePicker(context),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          labelText: 'Date',
                          labelStyle:
                              TextStyle(color: hexStringToColor('#4364F7')),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => myDatePicker(context),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        cursorColor: hexStringToColor('#4364F7'),
                        controller: _timeController,
                        onTap: () => myTimePicker(context),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          labelText: 'Time',
                          labelStyle:
                              TextStyle(color: hexStringToColor('#4364F7')),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: () => myTimePicker(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        child: const Text(
                          "Offer Pool",
                        ),
                        onPressed: () async {
                          if (_sourceTextController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg:
                                    "Source required, please enter an Source Address");
                          } else if (_destinationTextController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg:
                                    "Destination required, please enter an Destination Address");
                          } else if (_dateController.text.isEmpty) {
                            Fluttertoast.showToast(msg: "Please enter date");
                          } else if (_timeController.text.isEmpty) {
                            Fluttertoast.showToast(msg: "please enter time");
                          } else {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            final User? newUser = auth.currentUser;

                            String? tempId =
                                await getUserDocID(newUser!.email!);
                            print('userid is >>>>>  ----   $tempId');

                            String? tempPhone =
                                await getUserInfo(tempId!, 'phone');
                            String? tempUsername =
                                await getUserInfo(tempId, 'username');
                            String? tempDriverEmail =
                                await getUserInfo(tempId, 'email');

                            setState(() {
                              Source = _sourceTextController.text;
                              Destination = _destinationTextController.text;
                              Date = _dateController.text;
                              Time = _timeController.text;

                              driverPhone = tempPhone!;
                              driverName = tempUsername!;
                              driverEmail = tempDriverEmail!;
                            });

                            // print('userid is >>>>>  ----   $id');
                            print('user uid >>>    ${newUser.uid}');

                            await checkAndCreateDocument(newUser.uid);
                          }
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const MainScreen()));*/
                          //await driverRides.add({"username":driverName,"phone":driverPhone,"driverId ": user.uid,"Source": Source, "Destination": Destination, "Date": Date, "Time": Time, "RideStatus": rideStatus, "NumberOfSeatsAvailable": numberOfSeatAvailable});

                          // await _rides.doc(id).set({"username":driverName,"phone":driverPhone,"driverId ": id,"email ": driverEmail,"Source": Source, "Destination": Destination, "Date": Date, "Time": Time, "RideStatus": rideStatus, "NumberOfSeatsAvailable": numberOfSeatAvailable});
                        },
                        style: ElevatedButton.styleFrom(
                            primary: hexStringToColor('#4364F7'),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                )),
          ],
        ));
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    ProgressBar(
      message: "Please Wait ....",
    );
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            sourceLatLng, destinationLatLng);

    print("There are points:   ");
    print(directionDetailsInfo!.e_points);
  }
}

const String rideStatus = 'inprogress';
int numberOfSeatAvailable = 3;
