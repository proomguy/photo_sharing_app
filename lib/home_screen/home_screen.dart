import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_sharing/log_in/login_screen.dart';
import 'package:photo_sharing/owner_details/owner_details.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String changeTitle = "Grid View";
  bool checkView = false;
  
  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void _uploadImage() async{
    if(imageFile == null){
      Fluttertoast.showToast(msg: "Please select an image");
      return;
    }
    try{
      final ref = FirebaseStorage.instance.ref().child('userImages').child(DateTime.now().toString() + '.jpg');
      await ref.putFile(imageFile!);
      imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('wallpaper').doc(DateTime.now().toString()).set({
        'id' : _auth.currentUser!.uid,
        'userImage' : myImage,
        'name' : myName,
        'email' : _auth.currentUser!.email,
        'image' : imageUrl,
        'downloads' : 0,
        'createdAt' :DateTime.now(),
      });
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      imageFile = null;
    }
    catch(error){
      Fluttertoast.showToast(msg: error.toString());
    }
  }
  
  void readUserInfo() async{
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then<dynamic>((DocumentSnapshot snapshot) async{
      myImage = snapshot.get('userImage');
      myName = snapshot.get('name');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readUserInfo();
  }

  Widget listViewWidget(String docId, String img, String userImg, String name, DateTime dateTime, String userId, int downloads){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 16.0,
        shadowColor: Colors.white10,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.amberAccent.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9]
              )
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OwnerDetails(
                    img: img,
                    userImg: userImg,
                    name: name,
                    dateTime: dateTime,
                    docId: docId,
                    userId: userId,
                    downloads: downloads,
                  )));
                },
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    bottom: 8.0
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        userImg
                      ),
                    ),
                    const SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Text(
                          DateFormat("dd MMMM, yyyy - hh:mm a").format(dateTime).toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //This code defines a Flutter widget called "listViewWidget" that takes several arguments as input and returns a UI element that displays information about an image.

//The widget is a Padding widget that wraps a Card widget. The Card widget has an elevation and a shadow color, and it contains a Container widget.

//The Container widget has a BoxDecoration with a LinearGradient background, and it also has padding. Inside the container, there is a Column widget that contains several other UI elements.

//The first element is a GestureDetector widget that wraps an Image.Network widget. The Image.network widget displays the image passed in the "img" argument, and it is set to fit the cover of the screen. The GestureDetector widget is set to call a function when tapped, but the function is not defined in this code snippet.

//The next element is a SizedBox widget with a fixed height, followed by a Padding widget that wraps a Row widget. The Row widget contains a CircleAvatar widget that displays an image, which is passed in the "userImg" argument, and a Column widget that displays text.

//The CircleAvatar widget has a fixed radius and displays the user's image passed in the "userImg" argument. The Column widget contains two text widgets, the first one displays the name passed in the "name" argument and the second text widget displays the date and time passed in the "dateTime" argument with a specific format.

//Overall, this code creates a UI element that displays an image, the user's name, the date and time the image was created, and the user's profile picture.

  Widget gridViewWidget(String docId, String img, String userImg, String name, DateTime dateTime, String userId, int downloads){
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(6.0),
      crossAxisCount: 1,
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.amberAccent.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9]
              )
          ),
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OwnerDetails(
                img: img,
                userImg: userImg,
                name: name,
                dateTime: dateTime,
                docId: docId,
                userId: userId,
                downloads: downloads,
              )));
            },
            child: Center(
              child: Image.network(
                img,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
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
                  _uploadImage();
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
          title: GestureDetector(
            onTap: (){
              setState(() {
                changeTitle = "List View";
                checkView = true;
              });
            },
            onDoubleTap: (){
              setState(() {
                changeTitle = "Grid View";
                checkView = false;
              });
            },
            child: Text(changeTitle),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            child: const Icon(Icons.logout_outlined),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('wallpaper').orderBy("createdAt", descending: true).snapshots(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data!.docs.isNotEmpty){
                if(checkView == true){
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index){
                      return listViewWidget(
                        snapshot.data!.docs[index].id,
                        snapshot.data!.docs[index]['image'],
                        snapshot.data!.docs[index]['userImage'],
                        snapshot.data!.docs[index]['name'],
                        snapshot.data!.docs[index]['createdAt'].toDate(),
                        snapshot.data!.docs[index]['id'],
                        snapshot.data!.docs[index]['downloads'],
                      );
                    }                    
                  );
                }
                else{
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                    ),
                      itemBuilder: (BuildContext context, int index){
                        return gridViewWidget(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]['image'],
                          snapshot.data!.docs[index]['userImage'],
                          snapshot.data!.docs[index]['name'],
                          snapshot.data!.docs[index]['createdAt'].toDate(),
                          snapshot.data!.docs[index]['id'],
                          snapshot.data!.docs[index]['downloads'],
                        );
                      }
                  );
                }
              }
              else{
                return const Center(
                  child: Text('There is no tasks',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20
                    ),
                  ),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went terribly wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}