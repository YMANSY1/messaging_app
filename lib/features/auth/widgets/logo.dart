import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        children: [
          const TextSpan(
            text: 'Welcome to ',
            style: TextStyle(color: Color(0xFFCC5353)), // soft gray
          ),
          TextSpan(
            text: 'In',
            style: TextStyle(color: Colors.deepPurple),
          ),
          TextSpan(
            text: 'Sync',
            style: TextStyle(color: Colors.teal),
          ),
        ],
      ),
    );
  }
}
