import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/auth/auth_service.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/utils/utility.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('signupScreen');
  }

  void signIn() async {
  final authService = Provider.of<AuthService>(context, listen: false);

  try {
    // Vérifier si l'adresse e-mail est vide
    if (emailController.text.trim().isEmpty) {
      // throw Exception('Email cannot be empty');
      toast(message: 'Email cannot be empty');
    }

    // Vérifier si le mot de passe est vide
    if (passwordController.text.trim().isEmpty) {
      // throw Exception('Password cannot be empty');
      toast(message: 'Password cannot be empty');
    }

    // Appeler la fonction d'authentification
    await authService.signInWithEmailandPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    // Afficher un message de succès
    toast(message: 'Sign in successful!');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );

  } catch (e) {
    String errorMessage = 'An error occurred. Please try again.';

    // Personnaliser les messages d'erreur en fonction du type d'erreur
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Invalid email or password';
          break;
      }
    } else if (e is Exception) {
      errorMessage = e.toString();
      
    }

    // Afficher le message d'erreur
    toast(message: errorMessage);
  }
}


  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/note.png",
                  height: 150,
                ),
                //title
                const Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                //sub title
                const Text(
                  'Welcome back! Nice to see you agin',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20,),
                //mail textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                          child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18),
                      )
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                //text sigup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not yet a member? '),
                    GestureDetector(
                      onTap: openSignupScreen,
                      child: Text(
                        'Sign up now',
                        style: TextStyle(
                          color: Colors.blue[400],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
