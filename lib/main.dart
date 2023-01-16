import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photo_sharing/log_in/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text("Welcome to photo sharing app"),
                ),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text("Ooops, we have an error"),
                ),
              ),
            ),
          );

        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Photo sharing App",
          home: LoginScreen(),
          );
      }
    );
  }
}


