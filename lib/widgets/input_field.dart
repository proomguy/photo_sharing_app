import 'package:flutter/material.dart';
import 'package:photo_sharing/widgets/text_field_container.dart';

class InputField extends StatelessWidget{

  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final TextEditingController textEditingController;

  InputField({
    required this.hintText,
    required this.iconData,
    required this.obscureText,
    required this.textEditingController
});

  @override
  Widget build(BuildContext context){
    return TextFieldContainer(
      child: TextField(
        cursorColor: Colors.white,
        obscureText: obscureText,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          helperStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          prefixIcon: Icon(iconData, color: Colors.white, size: 20,),
          border: InputBorder.none,
        ),
      ),
    );
  }
}