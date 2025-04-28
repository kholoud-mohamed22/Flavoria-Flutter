import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/widgets/favoritesService.dart';
import 'package:flavoria/widgets/rating_bar.dart';
import 'package:flavoria/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  final String img;
  final double rate;
  final String name;
  final String description;
  final Map ingredients;
  final String video;
  final String id;
  final bool fav;
  final int time;

  const Details(
      {super.key,
      required this.img,
      required this.name,
      required this.rate,
      required this.time,
      required this.description,
      required this.ingredients,
      required this.id,
      required this.fav,
      required this.video});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  FavoritesService favoritesService = FavoritesService();
  late Map<String, dynamic> mealData;
  late String mealId;
  bool isFavorite = false;

// معلومات الوجبة

// mealId دا ممكن يكون ID من API أو تعمليه بنفسك

  @override
  void initState() {
    mealId = widget.id;
    mealData = {
      'mealName': widget.name,
      'image': widget.img,
      'time': widget.time,
      'rate': widget.rate,

      // ممكن تضيفي أي حاجة تانية حسب تطبيقك
    };
    isFavorite = widget.fav;
    checkIfFavorite();
    super.initState();
  }

  Future<void> checkIfFavorite() async {
    isFavorite = await favoritesService.checkIfFavorite(mealId);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // صورة الطبق
            Stack(
              children: [
                Image.network(
                  widget.img,
                  height: screenHeight * 0.6, // نصف الشاشة
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Positioned(
                    top: 15,
                    right: 12,
                    child: IconButton(
                      onPressed: () async {
                        if (isFavorite) {
                          await favoritesService.removeFavoriteMeal(
                              mealId, context);

                          setState(() {
                            isFavorite = false;
                          });
                        } else {
                          await favoritesService.addFavoriteMeal(
                              mealId, mealData, context);
                          setState(() {
                            isFavorite = true;
                          });
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),

            // الكارد متراكب مع الصورة والنص
            Transform.translate(
              offset:
                  Offset(0, -50), // لتحريكه للأعلى قليلًا ليكون نصفه على الصورة
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 120,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RECIPE',
                        style: GoogleFonts.poppins(
                            color: AppColors.basicColor,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.name,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.basicColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      RatingBarWidget(rate: widget.rate),
                    ],
                  ),
                ),
              ),
            ),

            // النصوص والوصف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.description,
                    style: TextStyle(color: AppColors.basicColor, fontSize: 16),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.ingredients.length,
                      itemBuilder: (context, index) {
                        String ingredient =
                            widget.ingredients.keys.elementAt(index);
                        String quantity = widget.ingredients[ingredient] ?? '';
                        return Row(
                          children: [
                            Image.network(
                              'https://www.themealdb.com/images/ingredients/$ingredient-Small.png',
                              width: 50,
                              height: 50,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  ingredient,
                                  style: TextStyle(color: AppColors.basicColor),
                                ),
                              ),
                            ),
                            Text(quantity,
                                style: TextStyle(color: AppColors.basicColor)),
                          ],
                        );
                      }),

                  SizedBox(height: 50), // مساحة إضافية للتمرير
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
