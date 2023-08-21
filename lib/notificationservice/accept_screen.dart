import 'package:flutter/material.dart';

class AcceptScreen extends StatefulWidget {
  final String id;
  final String payloadid;
  final String phone;
  final String email;
  const AcceptScreen(
      {Key? key,
      required this.id,
      required this.payloadid,
      required this.phone,
      required this.email})
      : super(key: key);

  @override
  State<AcceptScreen> createState() => _AcceptScreenState();
}

class _AcceptScreenState extends State<AcceptScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Screen'),
      ),
      body: Container(
        child: Center(
            child: Column(
          children: [
            Text('Accepted'),
            Text('Random_Id is ${widget.id}'),
            Text('PayloadId is ${widget.payloadid}'),
            Text('phone is ${widget.phone}'),
            Text('email is ${widget.email}'),
          ],
        )),
      ),
    );
  }
}
