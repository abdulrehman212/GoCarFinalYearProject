import 'package:flutter/cupertino.dart';
import 'package:fyp_gocar/models/directions.dart';

class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation;
  Directions? userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateuserDropOffLocation(Directions userDropOffLocation)
  {
    userPickUpLocation = userDropOffLocation;
    notifyListeners();
  }
}