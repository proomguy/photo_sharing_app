import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:photo_sharing/home_screen/home_screen.dart';
import 'package:photo_sharing/widgets/button_square.dart';

class OwnerDetails extends StatefulWidget{

  String? img;
  String? userImg;
  String? name;
  DateTime? dateTime;
  String? docId;
  String? userId;
  int? downloads;

  OwnerDetails({
    this.img,
    this.userImg,
    this.name,
    this.dateTime,
    this.docId,
    this.userId,
    this.downloads
});

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  
  int? total;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.lightBlueAccent],
            begin: Alignment.centerRight,
            end: Alignment.centerRight,
            stops: [0.2, 0.9]
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.lime,
                  child: Column(
                    children: [
                      Image.network(
                        widget.img!,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0,),
                const Text(
                  'Owner data Information',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15.0,),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.userImg!
                      ),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                  'Uploaded by : ${widget.name!}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                  DateFormat("dd MMMM, yyyy - hh:mm a").format(widget.dateTime!).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_outlined,
                      size: 40,
                      color: Colors.amber,
                    ),
                    Text(
                      " ${widget.downloads}", //Replaced with interpolation
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ButtonSquare(
                    text: "Download",
                    colors1: Colors.green,
                    colors2: Colors.greenAccent,
                    press: () async {
                      try{
                        var imageId = await ImageDownloader.downloadImage(widget.img!);
                        if(imageId == null){
                          return;
                        }
                        else{
                          Fluttertoast.showToast(msg: "Image saved to Gallery");
                          total = widget.downloads! + 1;
                          FirebaseFirestore.instance.collection('wallpaper').doc(widget.docId)
                              .update({'downloads' : total}).then((value) async {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                          });
                        }
                      }
                      on PlatformException catch(error){
                        if (kDebugMode) {
                          print(error);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}