import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavoria/pages/homeAppPage.dart';
import 'package:flavoria/pages/navPages/Home.dart';
import 'package:flavoria/pages/welcomePage.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('==========================User is currently signed out!');
    } else {
      print(user);
      print('==============================User is signed in!');
    }
  });
  runApp(const flavoria());
}

class flavoria extends StatelessWidget {
  const flavoria({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? Welcome() : HomeApp(),
    );
  }
}
