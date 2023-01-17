import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  File? imageFile;

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
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.greenAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.2, 0.9]
          )
      ),
      child: Scaffold(
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                heroTag: "1",
                backgroundColor: Colors.amber.shade400,
                onPressed: (){
                  //We shall create an event for calling images from the camera or the gallery
                  _showImageDialog();
                },
                child: const Icon(Icons.camera_enhance_sharp),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                heroTag: "2",
                backgroundColor: Colors.amber.shade800,
                onPressed: (){
                  //Here we going to create an upload image code
                  //upload_image
                },
                child: const Icon(Icons.cloud_upload_outlined),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.2, 0.9]
                )
            ),
          ),
        ),
      ),
    );
  }
}