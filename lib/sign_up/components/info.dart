import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing/widgets/button_square.dart';
import 'package:photo_sharing/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


class Credentials extends StatefulWidget{
  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials>{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _fullNameController = TextEditingController(text: "");
  final TextEditingController _emailTextController = TextEditingController(text: "");
  final TextEditingController _passTextController = TextEditingController(text: "");
  final TextEditingController _phoneNumberController = TextEditingController(text: "");

  File? imageFile;
  String? imageUrl;

  void _showImageDialog(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Take photos or load from Gallery?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  //We going to get from camera here, we work on this
                  //getFromCamera
                  _getFromCamera();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  //We going to get from Gallery, we work it out here
                  //getImageFrom gallery
                  _getFromGallery();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.browse_gallery,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: filePath,maxHeight: 1080, maxWidth: 1080);
    if(croppedImage != null){
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              //This is where we going to create show image dialer and load image as avatar to the application
              _showImageDialog();
            },
            child: CircleAvatar(
              radius: 70,
              backgroundImage: imageFile == null ?
                  const AssetImage("images/avatar.png") :
                  Image.file(imageFile!).image,
            ),
          ),
          const SizedBox(height: 10.0,),
          InputField(
            hintText: "Enter Username",
            iconData: Icons.person,
            obscureText: false,
            textEditingController: _fullNameController,
          ),
          const SizedBox(height: 10.0,),
          InputField(
            hintText: "Enter Email",
            iconData: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailTextController,
          ),
          const SizedBox(height: 10.0,),
          InputField(
            hintText: "Enter Password",
            iconData: Icons.lock,
            obscureText: true,
            textEditingController: _passTextController,
          ),
          const SizedBox(height: 10.0,),
          InputField(
            hintText: "Enter Phone Number without code",
            iconData: Icons.phone,
            obscureText: false,
            textEditingController: _phoneNumberController,
          ),
          const SizedBox(height: 15.0,),
          ButtonSquare(
            text: "Create Account",
            colors1: Colors.lightGreen,
            colors2: Colors.lightGreenAccent,
            press: () async {
              if(imageFile == null){
                Fluttertoast.showToast(msg: "Please select an Image");
                return;
              }
              try{
                final ref = FirebaseStorage.instance.ref().child('userImages').child(DateTime.now().toString() + '.jpg');
                await ref.putFile(imageFile!);
                imageUrl = await ref.getDownloadURL();
                await _auth.createUserWithEmailAndPassword(
                  email: _emailTextController.text.trim().toLowerCase(),
                  password: _passTextController.text.trim(),
                );
                final User? user = _auth.currentUser;
                final _uid = user!.uid;
                FirebaseFirestore.instance.collection('users').doc(_uid).set({
                  'id' : _uid,
                  'userImage' : imageUrl,
                  'name' : _fullNameController.text,
                  'email' : _emailTextController.text,
                  'phoneNumber' : _phoneNumberController.text,
                  'createAt' : Timestamp.now(),
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }
              catch(error){
                Fluttertoast.showToast(msg: error.toString());
              }
              //Navigate the user to the home page
            }
          ),
        ],
      ),
    );
  }
}