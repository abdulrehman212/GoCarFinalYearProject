import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/SplashScreen/splash_screen.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/screen/user_driver_screen.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profiletesting extends StatefulWidget {
  const profiletesting({super.key});

  @override
  State<profiletesting> createState() => _profiletestingState();
}

class _profiletestingState extends State<profiletesting> {

  String? userCollectionName;

  var userlogout = FirebaseAuth.instance;


  String username = 'Fetching username';
  String email = 'Fetching email';
  String phone = 'Fetching phone';

  Future<String?> getUserID(String email) async {
    try {
      String? id;
      await FirebaseFirestore.instance
          .collection(userCollectionName!)
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        id = value.docs.first.id;
      });
      return id;
    } catch (e) {
      return 'Error fetching user';
    }
  }
  
  
  Future<String?> getUserInfo(String USERID, String KEY) async {
    try {
      CollectionReference currentusers =
          FirebaseFirestore.instance.collection(userCollectionName!);
      final snapshot = await currentusers.doc(USERID).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data[KEY];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  void getUserData()async {
    
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? newUser = auth.currentUser;
  print('printing email ------------>    '+newUser!.email.toString());

  if(await getUserCollectionName(newUser.email!) == 'usersData'){
      setState(() {
        userCollectionName = 'usersData';
      });
    }
    else if(await getUserCollectionName(newUser.email!) == 'DriverData'){
      setState(() {
        userCollectionName = 'DriverData';
      });

    }
    else{
      showDialog(
        
        context: context,
        builder: (BuildContext context11) {
        return AlertDialog(
        title: Text('Error!'),
        content: Text('A problem occured! '),
        actions: [
        TextButton(
        onPressed: () async{
        Navigator.of(context11).pop();
        },
        child: Text('OK'),

             ),
            ],
           );
          },
        );


    }
    print('collection name is : >>>>     $userCollectionName');


   String? id = await getUserID(newUser.email.toString());

  print('printing id ------------>    '+id!);

  String? tempEmail = await getUserInfo(id ,'email');
  String? tempPhone = await getUserInfo( id , 'phone' );
  String? tempUsername = await getUserInfo(id , 'username');

  setState(() {
    email = tempEmail!;
    phone = tempPhone!;
    username = tempUsername!;
  });

}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();

  }


  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        title: Text("Settings Page"),
        backgroundColor: hexStringToColor('#4364F7'),
        surfaceTintColor: Colors.black12,
        automaticallyImplyLeading : false,
      ),
      body: Container(
        child: Column(
          children: [
            Text(username),
            Text(email),
            Text(phone),
            ElevatedButton(onPressed: ()async{
              final sharedpref = await SharedPreferences.getInstance();
                      sharedpref.setBool(MySplashScreenState.KEYLOGIN, false);
                      
                      setState(() {
                        userCollectionName = null;
                        // // login = false;
                        // Get.delete<DataController>();
                        // controller.clearUserData();

                      });
                      userlogout.signOut();
                      print(userCollectionName);
                      
                      // sharedpref.clear();
                      
                      // ignore: use_build_context_synchronously
                      Navigator.pop(mainContext);
                      Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const user_driver_screen_view())
              );
            }, child: Text('logout'),
            ),
          ],
        ),

      )
    );
  }
}