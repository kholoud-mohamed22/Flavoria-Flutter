import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/main.dart';
import 'package:flavoria/pages/details.dart';
import 'package:flavoria/pages/navPages/Plan.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/favoritesService.dart';
import 'package:flavoria/widgets/rating_bar.dart';
import 'package:flavoria/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MealCard extends StatefulWidget {
  final delete;
  String? day;
  final MealModel meal;
  final fromPlan;

  MealCard({
    super.key,
    required this.meal,
    this.delete,
    this.fromPlan,
    this.day,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  int randomTime = 10 + Random().nextInt(51);
  final double randomRating = 1 + Random().nextDouble() * 4;

  late Map<String, dynamic> mealData;
  late String mealId;
  bool isFavorite = false;
  FavoritesService favoritesService = FavoritesService();

// معلومات الوجبة

// mealId دا ممكن يكون ID من API أو تعمليه بنفسك

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> addMealinDay(MealModel meal) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('plan')
        .doc('days')
        .collection(widget.day!)
        .doc(meal.Id)
        .set({
      'name': meal.Name,
      'image': meal.Image,
    });
    if (mounted) {
      setState(() {});
    }

    print(meal.Name);
  }

  @override
  void initState() {
    mealId = widget.meal.Id;
    mealData = {
      'mealName': widget.meal.Name,
      'image': widget.meal.Image,
      'time': randomTime,
      'rate': randomRating,

      // ممكن تضيفي أي حاجة تانية حسب تطبيقك
    };
    checkIfFavorite();
    super.initState();
  }

  Future<void> checkIfFavorite() async {
    isFavorite = await favoritesService.checkIfFavorite(mealId);
    if (mounted) {
      setState(() {});
    }
  }

  void updatePlan() {
    setState(() {
      // يمكنك إضافة أو تعديل العناصر التي تحتاج إلى تحديثها في الخطة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: GestureDetector(
        onTap: () async {
          if (widget.fromPlan == true) {
            // إضافة الوجبة إلى Firebase هنا
            await addMealinDay(widget.meal);
            Plan(
              update: updatePlan,
            );
            Navigator.pop(
              context,
            ); // العودة إلى صفحة الخطة
            return;
          }

          List<MealModel> detailedMeal =
              await request(Type: 'lookup.php?i=${widget.meal.Id}');

          if (detailedMeal.isNotEmpty) {
            Navigator.push(
              context,
              createScaleRoute(Details(
                rate: randomRating,
                description: detailedMeal[0].Description,
                img: detailedMeal[0].Image,
                name: detailedMeal[0].Name,
                ingredients: detailedMeal[0].Ingredients,
                video: detailedMeal[0].Video,
                id: widget.meal.Id,
                time: randomTime,
                fav: isFavorite,
              )),
            );
          }
        },
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      height: 230,
                      width: double.infinity,
                      widget.meal.Image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                      bottom: 15,
                      left: 12,
                      child: Text(
                        '$randomTime min',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                  Positioned(
                      top: 15,
                      right: 12,
                      child: IconButton(
                        onPressed: () async {
                          if (FirebaseAuth.instance.currentUser == null) {
                            showCustomSnackBar(context, 'Login First',
                                isError: true);
                            return;
                          }
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
                  widget.delete == true
                      ? Positioned(
                          top: 15,
                          left: 12,
                          child: IconButton(
                              onPressed: () async {
                                await firestore
                                    .collection('users')
                                    .doc(userId)
                                    .collection('plan')
                                    .doc('days')
                                    .collection(widget.day!)
                                    .doc(widget.meal.Id)
                                    .delete();
                                if (mounted) {
                                  setState(() {
                                    // يمكنك هنا إزالة الوجبة من القائمة يدويًا
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              )))
                      : SizedBox.shrink()
                ],
              ),
              RatingBarWidget(rate: randomRating),
              Text(
                widget.meal.Name,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.basicColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route createScaleRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
  );
}
