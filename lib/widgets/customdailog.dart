import 'package:flutter/material.dart';

Widget buildCustomDailog(
    BuildContext context, String mainText, String subtext) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      height: 350,
      decoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/smile.png',
                height: 120,
                width: 120,
              ),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            mainText,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Text(
              subtext,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Change the color here
              ),
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
              child: Text('OK'),
            ),
          ),
        ],
      ),
    ),
  );
}
