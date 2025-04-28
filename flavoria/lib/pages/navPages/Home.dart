import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/welcomePage.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flavoria/widgets/page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Welcome()),
                      (route) => false);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Daily Inspiration',
                style: GoogleFonts.poppins(
                    // استبدلي "poppins" بأي خط آخر تفضليه
                    color: AppColors.basicColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              child: PageViewWidget(
                firstItem: 2,
              ),
            ),
            Container(
              width: 300,
              height: 300,
              child: PageViewWidget(
                firstItem: 2,
              ),
            ),
            Container(
              width: 300,
              height: 300,
              child: PageViewWidget(
                firstItem: 2,
              ),
            )
          ],
        ));
  }
}
