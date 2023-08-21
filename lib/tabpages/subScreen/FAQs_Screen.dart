import 'package:flutter/material.dart';
import 'package:fyp_gocar/utils/color_utils.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is GoCar?',
      'answer':
          'GoCar is a ride-sharing service that connects drivers and passengers. It allows drivers to earn money by offering rides to passengers going in the same direction.',
    },
    {
      'question': 'How do I book a ride?',
      'answer':
          'To book a ride, simply open the GoCar app and enter your pickup and drop-off locations. The app will show you a list of available drivers and their estimated arrival times. Select a driver and confirm your booking.',
    },
    {
      'question': 'How much does a ride cost?',
      'answer':
          'The cost of a ride depends on several factors, such as distance, time, and demand. GoCar uses a dynamic pricing model that adjusts the fare based on these factors. The app will show you the estimated fare before you confirm your booking.',
    },
    {
      'question': 'Is GoCar safe?',
      'answer':
          'Yes, GoCar is safe. We take the safety and security of our users very seriously. All drivers undergo a background check and their vehicles are inspected to ensure they meet safety standards. We also have in-app features such as emergency assistance and driver ratings to help ensure a safe and comfortable ride for all users.',
    },
    {
      'question': 'What if I need to cancel a ride?',
      'answer':
          'If you need to cancel a ride, you can do so through the GoCar app. However, please note that there may be a cancellation fee depending on the timing of the cancellation.',
    },
  ];

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
        title: Text('FAQs'),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ExpansionTile(
              title: Text(faq['question']!,style: TextStyle(fontSize: 16),),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(faq['answer']!,style: TextStyle(fontSize: 16),),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
