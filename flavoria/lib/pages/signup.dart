import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/homeAppPage.dart';
import 'package:flavoria/pages/navPages/Home.dart';
import 'package:flavoria/pages/welcomePage.dart';
import 'package:flavoria/widgets/snackbar.dart';
import 'package:flavoria/widgets/textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
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
              const SizedBox(
                height: 10,
              ),
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
                "Sign Up",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.basicColor,
                    fontSize: 22),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Save delicious recipes and get personalized content.",
                style: TextStyle(color: AppColors.basicColor),
              ),
              const SizedBox(
                height: 50,
              ),
              TextfieldWidget(
                  controller: userNameController,
                  hint: 'Display Name',
                  password: false),
              const SizedBox(
                height: 20,
              ),
              TextfieldWidget(
                  controller: emailController, hint: 'Email', password: false),
              const SizedBox(
                height: 20,
              ),
              TextfieldWidget(
                  controller: passwordController,
                  hint: 'Password',
                  password: true),
              const SizedBox(
                height: 20,
              ),
              TextfieldWidget(
                  controller: password2Controller,
                  hint: 'Confirm Password',
                  password: true),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (userNameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          password2Controller.text.isEmpty) {
                        showCustomSnackBar(context, 'Please fill all fields',
                            isError: true);
                        return;
                      }

                      if (passwordController.text != password2Controller.text) {
                        showCustomSnackBar(context, 'Passwords do not match!',
                            isError: true);
                        return;
                      }
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      showCustomSnackBar(
                        context,
                        'Successful Sginup',
                      );
                      Navigator.push(context, createRoute(HomeApp()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showCustomSnackBar(
                            context, 'The password provided is too weak.',
                            isError: true);
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        showCustomSnackBar(context,
                            'The account already exists for that email.',
                            isError: true);
                        print('The account already exists for that email.');
                      } else if (e.code == 'invalid-email') {
                        showCustomSnackBar(
                            context, 'the email address is badly formatted',
                            isError: true);
                        print('the email address is badly formatted');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30)),
                      backgroundColor: AppColors.basicColor),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
