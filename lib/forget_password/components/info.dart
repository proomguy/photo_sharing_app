import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing/account_check/account_check.dart';
import 'package:photo_sharing/log_in/login_screen.dart';
import 'package:photo_sharing/sign_up/sign_up_screen.dart';
import 'package:photo_sharing/widgets/button_square.dart';
import 'package:photo_sharing/widgets/input_field.dart';

class Credentials extends StatelessWidget{

  final TextEditingController _emailTextEditingController = TextEditingController(text: '');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Center(
              child: Image.asset(
                "images/forget.png",
                width: 300.0,
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
          InputField(
            hintText: "Enter Email",
            iconData: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailTextEditingController,
          ),
          const SizedBox(height: 15.0,),
          ButtonSquare(
            text: "Send link",
            colors1: Colors.lime,
            colors2: Colors.limeAccent,
            press: () async {
              try{
                await _auth.sendPasswordResetEmail(email: _emailTextEditingController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.amber,
                  content: Text("Password Reset email has been sent",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  ),
                );
              }
              on FirebaseAuthException catch(error){
                Fluttertoast.showToast(msg: error.toString());
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
          TextButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
            child: const Center(child: Text("Create Account")),
          ),
          const SizedBox(height: 15.0,),
          AccountCheck(
            login: false,
            press: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}