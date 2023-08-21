import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  // final String id;
  // final String payloadid;
  // final String phone;
  // final String email;
  // const MessageScreen(
  //     {Key? key,
  //     required this.id,
  //     required this.payloadid,
  //     required this.phone,
  //     required this.email})
  //     : super(key: key);
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Screen'),
      ),
      body: Container(
        child: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text('#########      Message Screen       ########'),
            // Text('Random_Id is: ${widget.id}'),
            // const SizedBox(
            //   height: 30,
            // ),
            // Text('PayloadId is: ${widget.payloadid}'),
            // const SizedBox(
            //   height: 30,
            // ),
            // Text('phone is: ${widget.phone}'),
            // const SizedBox(
            //   height: 30,
            // ),
            // Text('email is: ${widget.email}'),
          ],
        )),
      ),
    );
  }
}
