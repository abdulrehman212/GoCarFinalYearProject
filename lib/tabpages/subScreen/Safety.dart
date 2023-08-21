import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fyp_gocar/utils/color_utils.dart';
import 'package:fyp_gocar/widgets/progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';


class Safety extends StatefulWidget {
  const Safety({super.key});

  @override
  State<Safety> createState() => _SafetyState();
}

class _SafetyState extends State<Safety> {

  final Uri ambulance = Uri.parse('tel:115');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        backgroundColor: hexStringToColor('#4364F7'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Safety'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Safety.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Who do you want to contact?',
                style: TextStyle(fontSize: 26),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  Icon(Icons.call, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Ambulance', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () async{
                     
                      if(await canLaunchUrl(ambulance)){
                        await launchUrl(ambulance);
                      }else{
                        ProgressBar(message: "Can't Lauch this URL...");
                      }                    
                      },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.call, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Police', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () async{
                      final Uri  url = Uri(
                        scheme: "tel",
                        path: "112",
                      ); 
                      if(await canLaunchUrl(url)){
                        await launchUrl(url);
                      }else{
                        ProgressBar(message: "Can't Lauch this URL...");
                      }                    
                      },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}