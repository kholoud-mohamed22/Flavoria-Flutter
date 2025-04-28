import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/SearchinPlan.dart';
import 'package:flavoria/pages/welcomePage.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flavoria/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Plan extends StatefulWidget {
  final VoidCallback? update;
  Plan({super.key, this.update});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  List<List<MealModel>> mealsperDays = [];

  Future fetchData() async {
    List<List<MealModel>> fetchedMealsPerDays = [];

    for (int i = 0; i < 7; i++) {
      List<MealModel> dailyMeals = [];
      for (int i = 0; i < 3; i++) {
        List<MealModel> mealList =
            await request(Type: 'random.php'); // طلب البيانات
        if (mealList.isNotEmpty) {
          dailyMeals.add(mealList.first);
        } // أخذ أول عنصر فقط من القائمة
        print('Fetched meals for $i: $mealList');
      }
      fetchedMealsPerDays.add(dailyMeals);
    }

    if (mounted) {
      setState(() {
        mealsperDays = fetchedMealsPerDays;
      });
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addMealsForDaysTofire() async {
    try {
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        String dayName = days[dayIndex];
        List<MealModel> dayMeals = mealsperDays[dayIndex];
        for (MealModel meal in dayMeals) {
          await firestore
              .collection('users')
              .doc(userId)
              .collection('plan')
              .doc('days')
              .collection(dayName)
              .doc(meal.Id)
              .set({
            'name': meal.Name,
            'image': meal.Image,
          });
        }
      }
      if (mounted) {
        await getPlanMeals(); // نجيب البيانات الجديدة بعد الإضافة ✅
        showCustomSnackBar(context, 'Meal added to Plan');
      }

      showCustomSnackBar(context, 'Meal added to Plan');
      print("Meal added to favorites ✅");
    } catch (e) {
      print("❌ Failed to add meal: $e");
    }
  }

  List<List<QueryDocumentSnapshot>> mealsIdsPerDay = [];

  getPlanMeals() async {
    mealsIdsPerDay.clear();
    for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
      String dayName = days[dayIndex];

      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('plan')
          .doc('days')
          .collection(dayName)
          .get();
      mealsIdsPerDay.add(querySnapshot.docs);
    }
    if (mounted) {
      setState(() {});
    }
  }

  deleteAllmeals() async {
    try {
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        String dayName = days[dayIndex];

        // التأكد من أن قائمة mealsIdsPerDay ليست فارغة
        if (mealsIdsPerDay.isNotEmpty && mealsIdsPerDay[dayIndex].isNotEmpty) {
          for (var mealDoc in mealsIdsPerDay[dayIndex]) {
            await firestore
                .collection('users')
                .doc(userId)
                .collection('plan')
                .doc('days')
                .collection(dayName)
                .doc(mealDoc.id)
                .delete();
          }
        }
      }

      showCustomSnackBar(context, 'All meals have been removed.');
    } catch (e) {
      print("❌ Failed to delete meals: $e");
    }
  }

  @override
  void initState() {
    widget.update;
    print(mealsIdsPerDay.length);
    getPlanMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 55,
              ),
              const Text(
                "This Week",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: AppColors.basicColor),
              ),
              const Text(
                "Ready to plan this week?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: AppColors.basicColor),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 16, right: 16),
                child: ElevatedButton(
                    onPressed: () async {
                      // أول حاجة نعرض الـ Dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.basicColor,
                          ),
                        ),
                      );

                      // بعدين ننفذ العمليات اللي انتي عايزاها
                      await deleteAllmeals();
                      await fetchData();
                      await addMealsForDaysTofire();

                      // وبعد ما نخلص نقفل الـ Dialog
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                      backgroundColor: AppColors.basicColor,
                    ),
                    child: const Text(
                      'START MY PLAN',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  days[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.basicColor),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        createRoute(Searchinplan(
                                          day: days[index],
                                        )));
                                  },
                                  child: Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: AppColors.basicColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            mealsIdsPerDay.isEmpty
                                ? CircularProgressIndicator(
                                    color: AppColors.basicColor,
                                  )
                                : SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: mealsIdsPerDay[index].length,
                                        itemBuilder: (context, mealIndex) {
                                          var meal =
                                              mealsIdsPerDay[index][mealIndex];
                                          MealModel m = MealModel(
                                              Image: meal["image"],
                                              Name: meal["name"],
                                              Id: meal.id,
                                              Description: '',
                                              Ingredients: {},
                                              Video: '');
                                          return MealCard(
                                            day: days[index],
                                            meal: m,
                                            delete: true,
                                          );
                                        }),
                                  )
                          ],
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
