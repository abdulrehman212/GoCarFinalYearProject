import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class ProgressBar extends StatelessWidget {
  String message;

  ProgressBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //backgroundColor: hexStringToColor("#4364F7"),
      backgroundColor: Color.fromARGB(214, 236, 228, 228),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 202, 216, 231),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const SizedBox(
                width: 6.0,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black26),
              ),
              const SizedBox(
                width: 26.0,
              ),
              Text(
                message,
                style: const TextStyle(
                    color: Color.fromARGB(255, 14, 13, 13),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
