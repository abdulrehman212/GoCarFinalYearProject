import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel
{
  String? username;
  String? phone;
  String? email;
  String? Uid;

  UserModel({this.username, this.phone, this.email, this.Uid});

  UserModel.fromSnapshot(DocumentSnapshot snap)
  {
    username = snap['username'];
    phone = snap['phone'];
    email = snap['email'];
    Uid = snap.id;
  }

  Future<void> saveDriverUidToRide(String rideId) async {
    await FirebaseFirestore.instance
        .collection('Rides')
        .doc(rideId)
        .update({'driverUid': Uid});
  }
  
}