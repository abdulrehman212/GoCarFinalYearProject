import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, message) {
  final snackBar = SnackBar(
    content: Text(message,
        style: const TextStyle(
            color: Color.fromARGB(255, 19, 18, 18),
            fontWeight: FontWeight.bold,
            fontSize: 16.0)),
    backgroundColor: Color.fromARGB(255, 103, 132, 212),
    // backgroundColor: const Color(0XFFFF6787),
    //backgroundColor: Colors.white70,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(25.0),
    elevation: 30,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
