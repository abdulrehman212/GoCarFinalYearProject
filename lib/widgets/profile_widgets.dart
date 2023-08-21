import 'package:flutter/material.dart';
import 'package:fyp_gocar/utils/color_utils.dart';

Widget introWidgetWithoutLogos(String title, BuildContext context){
  return Container(

    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mask.png'),
            fit: BoxFit.fill
        )
    ),
    height: 180,

    child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,

        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
            title, 
            style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 24),),

          ],
        )),

  );
}

Widget buildTextBox(BuildContext context, String label,String text,IconData iconData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(iconData,color: Colors.black54,),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }