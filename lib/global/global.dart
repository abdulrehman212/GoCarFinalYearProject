import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;

User? currentFirebaseUser;

var user = FirebaseAuth.instance.currentUser!;

Future<String> getmyUserType(String email) async {
  try {
    final driverDocs = await FirebaseFirestore.instance
        .collection('DriverData')
        .where('email', isEqualTo: email)
        .get();

    if (driverDocs.docs.isNotEmpty) {
      // Email belongs to a driver
      return 'driver';
    }

    final userDocs = await FirebaseFirestore.instance
        .collection('usersData')
        .where('email', isEqualTo: email)
        .get();

    if (userDocs.docs.isNotEmpty) {
      // Email belongs to a user
      return 'user';
    }

    // Email not found in either collection
    return 'error';
  } catch (e) {
    return 'error';
  }
}

Future<String> getUserCollectionName(String email) async {
  try {
    final driverDocs = await FirebaseFirestore.instance
        .collection('DriverData')
        .where('email', isEqualTo: email)
        .get();

    if (driverDocs.docs.isNotEmpty) {
      // Email belongs to a driver
      return 'DriverData';
    }

    final userDocs = await FirebaseFirestore.instance
        .collection('usersData')
        .where('email', isEqualTo: email)
        .get();

    if (userDocs.docs.isNotEmpty) {
      // Email belongs to a user
      return 'usersData';
    }

    // Email not found in either collection
    return 'error';
  } catch (e) {
    return 'error';
  }
}


