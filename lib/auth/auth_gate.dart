import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
       builder: (context , snapshot){
        //user is logged in
        if(snapshot.hasData){
          return const HomeScreen();
        }
        //user is not logged in
        else{
          return const LoginScreen();
        }
       }),
    );
  }
}