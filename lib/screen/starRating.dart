import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_gocar/widgets/reusable_widget.dart';
import 'package:fyp_gocar/widgets/toast_message.dart';
//import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class StarRatings extends StatefulWidget {
  String driverUid;
  StarRatings({super.key, required this.driverUid});

  @override
  State<StarRatings> createState() => _StarRatingsState();
}

class _StarRatingsState extends State<StarRatings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.driverUid);
    _reviewTextController = TextEditingController();
  }

  CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('Rating');

  final db = FirebaseFirestore.instance;

  TextEditingController _reviewTextController = TextEditingController();
  double newstar = 1;
/*
  void SaveAverageToFirestore(List<double> stars) async {
    if (stars.isEmpty) {
      print('The stars list is empty.');
      return;
    }

    double sum = 0.0;
    for (int i = 0; i < stars.length; i++) {
      sum += stars[i];
    }
    double average = sum / stars.length;
    print('Average: $average');

    CollectionReference ratingCollection =
        FirebaseFirestore.instance.collection('Rating');

    final documentReference = ratingCollection.doc(widget.driverUid);
    documentReference
        .update({'average': average})
        .then((_) => print('Average saved to Firestore successfully.'))
        .catchError((error) => print('Failed to save average: $error'));
  }
*/
  void saveAverageToFirestore(List<double> stars, double newRating) async {
    if (stars.isEmpty && newRating == null) {
      print('The stars list is empty and no new rating is provided.');
      return;
    }

    double sum = newRating ?? 0.0;
    int count = newRating == null ? 0 : 1;

    for (double star in stars) {
      if (star != null) {
        sum += star;
        count++;
      }
    }

    if (count == 0) {
      print('No valid stars in the list.');
      return;
    }

    double average = sum / count;
    print('Average: $average');

    CollectionReference ratingCollection =
        FirebaseFirestore.instance.collection('Rating');

    final documentReference = ratingCollection.doc(widget.driverUid);
    documentReference
        .update({'average': average})
        .then((_) => print('Average saved to Firestore successfully.'))
        .catchError((error) => print('Failed to save average: $error'));
  }

  void SaveRatingsToFirestore(
    String driverUid,
    List<String> userUid,
    List<double> ratingStars,
    List<String> ratingDescription,
    BuildContext context,
  ) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Rating');

    final documentReference = collectionReference.doc(driverUid);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final usersUids = List<String>.from(data['usersuids']);

        if (usersUids.isNotEmpty && usersUids.contains(userUid.first)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Failed!'),
                content: Text('You have already rated this driver.'),
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
          documentReference.update({
            'usersuids': FieldValue.arrayUnion(userUid),
            'ratingDescription': FieldValue.arrayUnion(ratingDescription),
            'ratingStars': FieldValue.arrayUnion(ratingStars),
          }).then((_) {
            final Stars = List<double>.from(data['ratingStars']);
            saveAverageToFirestore(Stars, ratingStars.first);
            print('Successfully saved the rating.');
          });
        }
      } else {
        documentReference.set({
          'driverUid': driverUid,
          'usersuids': userUid,
          'ratingDescription': ratingDescription,
          'ratingStars': ratingStars,
        });
        saveAverageToFirestore([], ratingStars.first);
        print('success 1st value created');
      }
    });
  }

  void saveRatingsToFirestore(
    String driverUid,
    List<String> userUids,
    List<double> ratingStars,
    List<String> ratingDescription,
    BuildContext context,
  ) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Rating');

    final documentReference = collectionReference.doc(driverUid);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final existingUserUids = List<String>.from(data['usersUids']);

        for (var i = 0; i < userUids.length; i++) {
          print(
              '#######################        i loop , uid , star, descip,            ####################');
          print(i);
          print(userUids[i]);
          print(ratingStars[i]);

          if (existingUserUids.isNotEmpty &&
              existingUserUids.contains(userUids[i])) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Failed!'),
                  content: Text('You have already rated this driver.'),
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
            documentReference.update({
              'usersUids': FieldValue.arrayUnion([userUids[i]]),
              'ratingDescription':
                  FieldValue.arrayUnion([ratingDescription[i]]),
              'ratingStars': FieldValue.arrayUnion([ratingStars[i]]),
            }).then((_) {
              final Stars = List<double>.from(data['ratingStars']);
              saveAverageToFirestore(Stars, ratingStars[i]);
              print('Successfully saved the rating.');
            });
          }
        }
      } else {
        documentReference.set({
          'driverUid': driverUid,
          'usersUids': userUids,
          'ratingDescription': ratingDescription,
          'ratingStars': ratingStars,
        });
        saveAverageToFirestore([], ratingStars.first);
        print('Success, 1st value created');
      }
    });
  }
/*
  Future<void> saveReviewToFirestore(
    String? email,
    String? rating,
    double stars,
  ) async {
    // Check if the review already exists in Firestore
    try {
      final querySnapshot = await reviewsCollection
          .where('userEmail', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        // Review doesn't exist, save it to Firestore
        await reviewsCollection.add({
          // 'driverEmail': driverEmail,
          'userEmail': email,
          'rating': rating,
          'stars': stars,
        });

        print('Review saved to Firestore.');
      } else {
        print('Review already exists in Firestore.');
      }
    } catch (e) {
      print('Error Occured!');
    }
  }
*/

  //final DocumentSnapshot documentSnapshot =currentFirebaseUser.email.contains('username');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: hexStringToColor('#4364F7'),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(65, 3, 12, 2),
            child: Text('Feedback'),
          ),
          //automaticallyImplyLeading: false,
          surfaceTintColor: Colors.black12,
        ),
        backgroundColor: Color.fromARGB(255, 201, 221, 223),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Card(
              color: Color.fromRGBO(255, 255, 255, 0.993),
              margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/rating.jpg',
                      height: 130,
                      width: 170,
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Center(
                      child: Text("HELLO!!",
                          style: TextStyle(
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 80, 209),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        'Your feedback is important to us. ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 82, 80, 209),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Please let us know, how was your ride?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 80, 209),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // ye star wale function ke liye hai//
                    Center(
                      child: RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            newstar = rating;
                          });
                          print(rating);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                        child: resuableTextField(
                            "Please give the feedback ",
                            Icons.feedback_rounded,
                            false,
                            _reviewTextController),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(
                            255, 12, 134, 233), // Background color
                        onPrimary: Colors.white, // Text color
                        elevation: 4, // Button elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(22), // Button border radius
                        ),
                        padding: EdgeInsets.all(10), // Button padding
                      ),
                      onPressed: () async {
                        String newrating = "";
                        setState(() {
                          newrating = _reviewTextController.text;
                        });
                        print("You pressed Icon Elevated Button");
                        FirebaseAuth auth = FirebaseAuth.instance;
                        User? newUser = auth.currentUser;
                        saveRatingsToFirestore(widget.driverUid, [newUser!.uid],
                            [newstar], [newrating], context);

                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const MainScreen()));*/
                      },
                      icon: Icon(
                          Icons.rate_review), //icon data for elevated button
                      label: const Text(
                        'Send Feedback',
                        style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                /*body: Center(
              child: RatingStars(
                value: value,
                onValueChanged: (v) {
                  //
                  setState(() {
                    value = v;
                  });
                },
                starBuilder: (index, color) => Icon(
                  Icons.star_border_outlined,
                  color: Color.fromARGB(255, 92, 38, 179),
                ),
                starCount: 5,
                starSize: 25,
                valueLabelColor: Color.fromARGB(255, 155, 155, 155),
                valueLabelTextStyle: const TextStyle(
                    color: Color.fromARGB(255, 29, 3, 3),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                valueLabelRadius: 10,
                maxValue: 5,
                starSpacing: 2,
                maxValueVisibility: true,
                valueLabelVisibility: true,
                animationDuration: Duration(milliseconds: 1200),
                valueLabelPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                valueLabelMargin: const EdgeInsets.only(right: 8),
                starOffColor: Color.fromARGB(255, 46, 9, 134),
                starColor: Colors.yellow,
              ),
                  ),*/
              ),
            ),
          ),
        ));
  }
}
