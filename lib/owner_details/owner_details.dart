import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              ],
            ),
          ],
        ),
      ),
    );
  }
}