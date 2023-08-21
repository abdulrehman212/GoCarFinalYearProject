import 'dart:async';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:fyp_gocar/screen/user_driver_screen.dart';
import '../utils/color_utils.dart';
import '../widgets/reusable_widget.dart';

// ignore: must_be_immutable
class Otpverification extends StatefulWidget {
  Otpverification({super.key, required this.useremail, required this.phone});
  String? useremail;
  String?
      phone; //use kar le isse jaha bhi chahiye    widget.phone kar kar k use karna

  @override
  State<Otpverification> createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  TextEditingController _OtpTextController = TextEditingController();

  EmailOTP myauth = EmailOTP();

  /*Future<void> verifyOTP(String OTP) async {
    if (await myauth.verifyOTP(otp: _OtpTextController.text) == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP is verified"),
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP is invalid")));
    }
  }*/

  late Timer timer;
  int second = 60;
  late bool isButtonActive = false;
  String buttonname = "Send";

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (second == 0) {
          setState(() {
            isButtonActive = true;
            timer.cancel();
            isButtonActive = false;
          });
        } else {
          setState(() {
            second--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 245, 245),
        // backgroundColor: Color.fromARGB(255, 233, 234, 236),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(child: Image.asset("assets/otp.png")),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Otp Verification!",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: hexStringToColor("#1F1F1F"),
                    fontSize: 20,
                    fontStyle: FontStyle.italic)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child:
                  Text("The OTP has sent to this email: ${widget.useremail}"),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
              child: resuableTextField("Enter OTP CODE For Verification",
                  Icons.verified_user_rounded, false, _OtpTextController),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(65, 6, 22, 6),
                child: ElevatedButton(
                    onPressed: isButtonActive
                        ? null
                        : () async {
                            myauth.setConfig(
                                appEmail: "aligocar04@gmail.com",
                                appName: "Go Car",
                                userEmail: widget.useremail,
                                otpLength: 6,
                                otpType: OTPType.digitsOnly);
                            startTimer();
                            setState(() {
                              second = 60;
                              isButtonActive = true;
                              buttonname = "Resend";
                            });
                            if (await myauth.sendOTP() == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("OTP has been sent"),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Sorry, OTP send failed"),
                              ));
                            }
                          },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.blueGrey;
                          }
                          return hexStringToColor('#4364F7');
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                    clipBehavior: Clip.none,
                    child: Text(buttonname)),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (await myauth.verifyOTP(otp: _OtpTextController.text) ==
                        true) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("OTP is verified"),
                      ));
                      await (Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const user_driver_screen_view())));
                    } else if (_OtpTextController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter OTP!"),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Invalid OTP!"),
                      ));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blueGrey;
                        }
                        return hexStringToColor('#4364F7');
                      }),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                  child: const Text("Verify OTP")),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Click Send OTP again in ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 7, 5, 5),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "00:$second",
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Color(0XFFFF4F5A),
                      fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " Sec",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 7, 5, 5),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ])));
  }
}
