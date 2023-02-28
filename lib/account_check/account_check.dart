import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget{

  final bool login;
  final VoidCallback press;

  const AccountCheck({Key? key,
    required this.login,
    required this.press
}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have an account" : "Already have an account?",
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white
          ),
        ),
        const SizedBox(width: 10.0,),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Create Account " : "Log in",
            style: const TextStyle(
                fontSize: 16.0,
                color: Colors.green,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 50.0,),
      ],
    );
  }
}