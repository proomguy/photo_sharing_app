import 'package:flutter/material.dart';
import 'components/heading_text.dart';
import 'components/info.dart';

class SignUpScreen extends StatelessWidget{
  const SignUpScreen({Key? key}) : super(key: key);


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
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeadText(),
                Credentials(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}