import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class mycurrentride extends StatefulWidget {
  const mycurrentride({super.key});

  @override
  State<mycurrentride> createState() => _mycurrentrideState();
}

class _mycurrentrideState extends State<mycurrentride> {
  
  String _text = 'Welcome, You have Booked a Ride!';


  double distance1 = 0;
  double distance2 = 0;
  double distance3 = 0;
  double dDistance = 0;

  double baseFare = 50;

  double seat1Fare = 0;
  double seat2Fare = 0;
  double seat3Fare = 0;

  void calculateFare() {
    double sum = distance1 + distance2 + distance3;
    double totalFare = baseFare * dDistance;
    seat1Fare = (distance1 / sum) * totalFare;
    seat2Fare = (distance2 / sum) * totalFare;
    seat3Fare = (distance3 / sum) * totalFare;
  }

  @override
  void initState() {
    super.initState();
    // Use the `Future.delayed` method to change the text after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _text = 'Congratulation, Your ride is Completed.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        title: Text("My Current Ride.",textAlign: TextAlign.center,),
        backgroundColor: hexStringToColor('#4364F7'),
        surfaceTintColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0,),
                Container(
                  decoration: BoxDecoration(
                  color: Color.fromARGB(255, 220, 115, 115),
                  borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    child: Text(_text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
               ),
                  ),   
             ],
           ),
                  ),
                ),
                const SizedBox(height: 20.0,),
      
                 Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    child: Text("Please input distance to Calculate Fares.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
               ),
                  ),   
             ],
           ),
                  ),
                   const SizedBox(height: 20.0,),
      
                Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Distance 1 (Kilometer)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  distance1 = double.parse(value);
                  calculateFare();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Distance 2 (Kilometer)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  distance2 = double.parse(value);
                  calculateFare();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Distance 3 (Kilometer)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  distance3 = double.parse(value);
                  calculateFare();
                });
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Driver Distance (Kilometer)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  dDistance = double.parse(value);
                  calculateFare();
                });
              },
            ),
          ),
          const SizedBox(height: 5.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seat 1 Fare: Rs ${seat1Fare.toStringAsFixed(2)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seat 2 Fare: Rs ${seat2Fare.toStringAsFixed(2)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seat 3 Fare: Rs ${seat3Fare.toStringAsFixed(2)}'),
          ),
          
                
         ],
        ),
      ),
    );
    }
}