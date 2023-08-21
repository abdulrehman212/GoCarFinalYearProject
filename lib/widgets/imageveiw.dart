import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.imagename});
  final String imagename;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagename,
      fit: BoxFit.fitWidth,
      width: 220,
      height: 220,
      //color: Colors.white,
    );
  }
}
