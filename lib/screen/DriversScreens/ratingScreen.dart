import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchAverageRating();
  }

  Future<void> fetchAverageRating() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? newUser = auth.currentUser;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Rating')
          .doc(newUser!.uid)
          .get();

      if (snapshot.exists) {
        var stars = snapshot.get('average');
        print('Fetched field value: $stars');
        setState(() {
          averageRating = stars;
        });
      }
    } catch (e) {
      print('Error fetching average rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Average Rating:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            _buildRatingStars(averageRating),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    double halfStar = rating - fullStars;
    int emptyStars = 5 - fullStars - (halfStar > 0 ? 1 : 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.yellow),
        if (halfStar > 0) Icon(Icons.star_half, color: Colors.yellow),
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: Colors.yellow),
      ],
    );
  }
}
