import 'package:flutter/material.dart';
import 'package:photo_sharing/log_in/components/info.dart';

import 'components/heading_text.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue, Colors.purpleAccent.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HeadText(),
                Credentials(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}