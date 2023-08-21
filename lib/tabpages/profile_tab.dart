import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/global/global.dart';
import 'package:fyp_gocar/widgets/profile_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SplashScreen/splash_screen.dart';
import '../screen/user_driver_screen.dart';
import '../utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {

  String? _imageFile = "";
  final ImagePicker _picker = ImagePicker();

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

    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? newUser = auth.currentUser;
    // print(newUser!.uid);
    getUserData();

  }

  @override
  Widget build(BuildContext mainContext) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: hexStringToColor('#4364F7'),
        automaticallyImplyLeading : false,
        surfaceTintColor: Colors.black12,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 8, right: 15),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      child: 
                      _imageFile == ""? 
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(70),
                          child: Image(
                              image: AssetImage(
                                  "assets/car1.png"),
                              width: 200,
                              height: 200,)
                              ),
                              )
                       :CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(70),
                            child: Image.file(
                                new File(_imageFile!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover)
                                ),
                                )
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Colors.white
                          ),
                          color: hexStringToColor('#4364F7'),
                        ),
                        child: InkWell(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottonSheet())
                              );
                          },
                          child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        ),

                      )
                      )
                  ],
                ),
              ),
              SizedBox(height: 30),

              buildTextBox(context,'Username',username,Icons.man_outlined),
              buildTextBox(context,'Email',email,Icons.email),
              buildTextBox(context,'Phone',phone,Icons.phone),
              
             
             // buildTextField("Password", "1234567", true),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    
                    onPressed: () async {
                      
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
                    }, 
                    child: Text("Logout", style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.white
                    )
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: hexStringToColor('#4364F7'),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                    ),
                ],
              )
            ],
          )
        ),
      )
    );
  }

Widget bottonSheet(){
  return Container(
    height: 100.0,
    width: 20.0,
    margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child:  Column(children:<Widget> [
      Text(
        "Choose Profile Photo",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
         
          children: [IconButton(
          icon: Icon(Icons.camera),
          onPressed: () {
            takephto(ImageSource.camera);
           },
          ),
          Text("Camera"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(width: 10.0),
        Column(
          
          children: [IconButton(
          icon: Icon(Icons.image),
          onPressed: () {
            takephto(ImageSource.gallery);
           },
          ),
          Text("Gallery"),
          ],
        ),
        ]
      ),
    ],
  
    ),
  );
}

void takephto(ImageSource source) async{
  final pickedFile = await _picker.pickImage(
    source: source,
    );
    setState(() {
      _imageFile = pickedFile!.path;
    });

 }
 

}

