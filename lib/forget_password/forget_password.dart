import 'package:flutter/material.dart';

import 'components/heading_text.dart';

class ForgetPasswordScreen extends StatelessWidget{

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
                HeadText(),
                //Credentials(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}