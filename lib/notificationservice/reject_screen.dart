import 'package:flutter/material.dart';

class RejectScreen extends StatefulWidget {
  final String id;
  final String payloadid;
  final String phone;
  final String email;
  const RejectScreen(
      {Key? key,
      required this.id,
      required this.payloadid,
      required this.phone,
      required this.email})
      : super(key: key);

  @override
  State<RejectScreen> createState() => _RejectScreenState();
}

class _RejectScreenState extends State<RejectScreen> {
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
