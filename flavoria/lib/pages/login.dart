import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/homeAppPage.dart';
import 'package:flavoria/pages/navPages/Home.dart';
import 'package:flavoria/pages/signup.dart';
import 'package:flavoria/pages/welcomePage.dart';
import 'package:flavoria/widgets/snackbar.dart';
import 'package:flavoria/widgets/textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.basicColor,
                  )),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Log In",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.basicColor,
                    fontSize: 22),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Welcom back! You're just a tap away from sothing delicious.",
                style: TextStyle(color: AppColors.basicColor),
              ),
              const SizedBox(
                height: 50,
              ),
              TextfieldWidget(
                  controller: email, hint: 'Email', password: false),
              const SizedBox(
                height: 20,
              ),
              TextfieldWidget(
                  controller: password, hint: 'Password', password: true),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (email.text.trim().isEmpty) {
                      showCustomSnackBar(
                        context,
                        "Enter your email address first.",
                        isError: true,
                      );
                      return;
                    }
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);
                      showCustomSnackBar(context,
                          "We've sent you a password reset email. Please check your inbox");
                    } on Exception catch (e) {
                      showCustomSnackBar(
                          context, 'Please enter a valid email address',
                          isError: true);
                      // TODO
                    }
                  },
                  child: const Text(
                    "I FORGOT MY PASSWORD",
                    style: TextStyle(
                        color: AppColors.basicColor,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.basicColor,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (email.text.isEmpty || password.text.isEmpty) {
                      showCustomSnackBar(context, 'Please fill all fields',
                          isError: true);
                      return;
                    }
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                      showCustomSnackBar(context, 'Successful Login');
                      Navigator.push(context, createRoute(HomeApp()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        showCustomSnackBar(
                            context, 'No user found for that email.',
                            isError: true);
                      } else if (e.code == 'invalid-credential') {
                        showCustomSnackBar(
                            context, 'Email or password is incorrect.',
                            isError: true);
                      } else if (e.code == 'too-many-requests') {
                        showCustomSnackBar(
                            context, 'Too many requests. Try again later.',
                            isError: true);
                      } else {
                        print('Error message: ${e.message}');
                        showCustomSnackBar(context, ' ${e.message}',
                            isError: true);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30)),
                      backgroundColor: AppColors.basicColor),
                  child: const Text(
                    'START COOKING!',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
