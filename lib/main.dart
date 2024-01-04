import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/auth/auth_gate.dart';
import 'package:flutterapp/auth/auth_service.dart';
import 'package:flutterapp/firebase_options.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/signup_screen.dart';
import 'package:provider/provider.dart';


void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context)=> AuthService(),
      child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      routes: {
        'homeScreen': (context) => const HomeScreen(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginScreen(),
      },
    );
  }
}
