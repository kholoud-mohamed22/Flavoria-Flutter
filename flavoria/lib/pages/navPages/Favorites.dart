import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/main.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<QueryDocumentSnapshot> mealsIds = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final user;

  getData() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    mealsIds.addAll(querySnapshot.docs);
    print('============================$mealsIds');
    print(mealsIds[0].id);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FirebaseAuth.instance.currentUser == null
          ? Center(child: Text('you not logged in '))
          : mealsIds == null
              ? CircularProgressIndicator(
                  color: AppColors.basicColor,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Your Favorites Meals',
                        style: TextStyle(
                            // استبدلي "poppins" بأي خط آخر تفضليه
                            color: AppColors.basicColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mealsIds.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // عدد الأعمدة
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.65, // عرض إلى ارتفاع العنصر
                        ),
                        itemBuilder: (context, index) {
                          var _meal = mealsIds[index];
                          MealModel m = MealModel(
                              Image: _meal["image"],
                              Name: _meal["mealName"],
                              Id: _meal.id,
                              Description: '',
                              Ingredients: {},
                              Video: '');
                          return Container(
                              width: 300,
                              height: 350,
                              child: MealCard(
                                meal: m,
                                onFavoriteRemoved: () {
                                  setState(() {
                                    mealsIds.removeAt(index);
                                  });
                                },
                              ));
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
