import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/utils/color_utils.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _textEditingController = TextEditingController();

  void _submitFeedback() {
    final feedback = _textEditingController.text;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usr = auth.currentUser;

    if (feedback.isNotEmpty) {
      // Save feedback to Firestore
      FirebaseFirestore.instance.collection('feedback').add({
        'feedback': feedback,
        'userId': usr!.uid,
        'userEmail': usr.email,
      }).then((value) {
        // Success! Feedback saved.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thank you!'),
              content: Text('Your feedback has been submitted.'),
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
      }).catchError((error) {
        // Error occurred while saving feedback
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to submit feedback. Please try again.'),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: hexStringToColor('#4364F7'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/smile.png',
                height: 200,
              ),
              SizedBox(height: 16.0),
              Text(
                'Your feedback may improve our services.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _textEditingController,
                maxLines: null,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: 'Enter your feedback (max 100 words)',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: hexStringToColor('#4364F7'),
                ),
                onPressed: _submitFeedback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
