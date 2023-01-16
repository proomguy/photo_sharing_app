import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing/account_check/account_check.dart';
import 'package:photo_sharing/forget_password/forget_password.dart';
import 'package:photo_sharing/home_screen/home_screen.dart';
import 'package:photo_sharing/sign_up/sign_up_screen.dart';
import 'package:photo_sharing/widgets/button_square.dart';
import 'package:photo_sharing/widgets/input_field.dart';

class Credentials extends StatelessWidget{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage(
                "images/logo1.png"
              ),
              backgroundColor: Colors.amber.shade300,
            ),
          ),
          const SizedBox(height: 15.0,),
          InputField(
            hintText: "Enter Email",
            iconData: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailTextController,
          ),
          const SizedBox(height: 15.0,),
          InputField(
            hintText: "Enter Password",
            iconData: Icons.lock,
            obscureText: true,
            textEditingController: _passTextController,
          ),
          const SizedBox(height: 15.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  //This is for the forget password section function, we will work on it later
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen()));
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7.0,),
          ButtonSquare(
            text: "Log In",
            colors1: Colors.red,
            colors2: Colors.redAccent,
            press: () async{
              try{
                await _auth.signInWithEmailAndPassword(
                  email: _emailTextController.text.trim().toLowerCase(),
                  password: _passTextController.text.trim(),
                );
                // I shall create a home screen here, This is the entry point to the system
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
              }
              catch(error){
                Fluttertoast.showToast(msg: error.toString());
              }
            },
          ),
          AccountCheck(
            login: true,
            press: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
          ),
        ],
      ),
    );
  }
}