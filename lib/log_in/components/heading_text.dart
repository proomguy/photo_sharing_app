import 'package:flutter/material.dart';

class HeadText extends StatelessWidget{

  Widget build(BuildContext context){

    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          const Center(
            child: Text("Photo Sharing", style: TextStyle(
              fontSize: 65,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Signatra"
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          const Center(
            child: Text("Log in", style: TextStyle(
              fontSize: 30,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontFamily: "Bebas"
              ),
            ),
          ),
        ],
      ),
    );
  }
}