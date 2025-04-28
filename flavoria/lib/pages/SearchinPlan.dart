import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flavoria/widgets/searchBar.dart';
import 'package:flutter/material.dart';

class Searchinplan extends StatefulWidget {
  String day;

  Searchinplan({super.key, required this.day});

  @override
  State<Searchinplan> createState() => _SearchinplanState();
}

class _SearchinplanState extends State<Searchinplan> {
  List<MealModel> Meals = [];
  Future fetchData() async {
    List<MealModel> fetchedMeals = [];

    for (int i = 0; i < 8; i++) {
      List<MealModel> mealList = await request(Type: 'random.php');
      if (mealList.isNotEmpty) {
        fetchedMeals.add(mealList.first);
      }
    }

    if (mounted) {
      setState(() {
        Meals = fetchedMeals;
      });
    }
  }

  final TextEditingController _searchController =
      TextEditingController(); // متحكم في حقل الإدخال للتحكم بالنص المكتوب بداخله
  List<String> _filteredItems = []; // قائمة لتخزين العناصر التي تتطابق مع البحث
  String _searchResult = ""; // متغير لتخزين النص الذي يتم تحديده بعد البحث

  List<String> _allItems = [];
  List<MealModel> searchList = [];
  // دالة لجلب البيانات من الـ API بناءً على النص المدخل
  Future fetchSearch(String query) async {
    if (query.isEmpty) return; // إذا كان النص فارغًا، لا نقوم بالبحث
    searchList = await request(Type: 'search.php?s=${query.trim()}');
    print(searchList);

    setState(() {
      _allItems.clear(); // مسح العناصر القديمة قبل إضافة عناصر جديدة
      for (int i = 0; i < searchList.length; i++) {
        _allItems.add(searchList[i].Name); // إضافة الأطعمة التي تم جلبها
      }
    });
  }

  void _updateSearchResults(String query) {
    fetchSearch(query); // جلب البيانات من الـ API بناءً على النص المدخل

    setState(() {
      // تصفية القائمة بناءً على النص المدخل
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList(); // الاحتفاظ فقط بالعناصر التي تحتوي على النص المدخل
    });
  }

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final userId = FirebaseAuth.instance.currentUser!.uid;
  // Future<void> addMealinDay(MealModel meal) async {
  //   await firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('plan')
  //       .doc('days')
  //       .collection(widget.day)
  //       .doc(meal.Id)
  //       .set({
  //     'name': meal.Name,
  //     'image': meal.Image,
  //   });
  //   if (mounted) {
  //     setState(() {});
  //   }

  //   print(meal.Name);
  // }

  @override
  void initState() {
    fetchData();
    print(widget.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("Add Recipe from Search",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.basicColor,
                    fontSize: 20,
                    fontStyle: FontStyle.italic)),
            const SizedBox(
              height: 20,
            ),
            CustomSearchWidget(
              searchController: _searchController,
              onChanged: _updateSearchResults,
              onSubmitted: (query) {
                // تنفيذ الكود عند الضغط على زر البحث
              },
              searchResult: _searchResult,
              searchList: searchList,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Meals.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.basicColor,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: Meals.length,
                      itemBuilder: (context, index) {
                        var meal = Meals[index];
                        return GestureDetector(
                            onTap: () async {
                              print(meal.Name);
                            },
                            child: MealCard(
                              meal: meal,
                              day: widget.day,
                              fromPlan: true,
                            ));
                      }),
            )
          ],
        ),
      ),
    );
  }
}
