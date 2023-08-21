import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_gocar/SplashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/color_utils.dart';

TextField resuablephoneTextField(String text, IconData icon,
    bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,

    //keyboardType:TextInputType.text,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: isPasswordType,
    cursorColor: Colors.white,

    style: TextStyle(color: Colors.black87.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 14),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromARGB(230, 77, 70, 70).withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.solid)),
    ),
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.phone,
  );
}

TextField resuableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,

    //keyboardType:TextInputType.text,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: isPasswordType,
    cursorColor: Colors.white,

    style: TextStyle(color: Colors.black87.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 14),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromARGB(230, 77, 70, 70).withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.solid)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

TextField DateTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.datetime,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.black87.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 14),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromARGB(230, 77, 70, 70).withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.solid)),
    ),
    /* keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,*/
  );
}
//second text feild below

TextField resuable_passTextField(String text, IconData icon,
    bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.black87.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 14),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromARGB(230, 77, 70, 70).withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.solid)),
    ),
  );
}

/*
TextFormField(
  controller: _controller,
  keyboardType: TextInputType.number,
  inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
 FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 
// for version 2 and greater youcan also use this
 FilteringTextInputFormatter.digitsOnly

  ],
  decoration: InputDecoration(
    labelText: "whatever you want",
    hintText: "whatever you want",
    icon: Icon(Icons.phone_iphone)
  )
)*/

Container logInButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 4),
      child: ElevatedButton(
        onPressed: () async {
          var sharedpref = await SharedPreferences.getInstance();
          sharedpref.setBool(MySplashScreenState.KEYLOGIN, true);
          onTap();
        },
        child: Text(
          isLogin ? 'LOGIN' : 'SIGN UP',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return hexStringToColor("#4364F7");
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
      ),
    ),
  );
}

Container SignUpButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 4),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          isLogin ? 'LOGIN' : 'SIGN UP',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return hexStringToColor("#4364F7");
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
      ),
    ),
  );
}

class CustomTextField extends StatefulWidget {
  const CustomTextField(
    String s, {
    super.key,
    // this.icon,
    this.hintText,
    this.controller,
    this.isObscure = false,
    this.validator,
    this.keyBoardType,
    this.inputForamatter,
    this.borderColor,
  });
  // final IconData? icon;
  final String? hintText;
  final TextEditingController? controller;
  final bool? isObscure;
  final String? Function(String?)? validator;
  final TextInputType? keyBoardType;
  final Color? borderColor;
  final List<TextInputFormatter>? inputForamatter;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width / 1.2,
      height: height / 14,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: widget.borderColor!),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isObscure!,
          keyboardType: widget.keyBoardType,
          inputFormatters: widget.inputForamatter,
          validator: widget.validator,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              top: height / 50,
              left: width / 30,
            ),
            // prefixIcon: Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 0.0),
            //   child: Icon(
            //     widget.icon,
            //     color: Colors.grey,
            //   ),
            // ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
