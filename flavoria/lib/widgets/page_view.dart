import 'package:flavoria/AppColors.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewWidget extends StatefulWidget {
  final int firstItem;

  const PageViewWidget({super.key, required this.firstItem});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late PageController _pageController;

  List<MealModel> Meals = [];

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.7);
    fetchData();

    super.initState();
  }

  Future fetchData() async {
    List<MealModel> fetchedMeals = [];

    for (int i = 0; i < 5; i++) {
      List<MealModel> mealList =
          await request(Type: 'random.php'); // طلب البيانات
      if (mealList.isNotEmpty) {
        fetchedMeals.add(mealList.first);
      } // أخذ أول عنصر فقط من القائمة
    }

    if (mounted) {
      setState(() {
        Meals = fetchedMeals;
      });

      Future.delayed(Duration(milliseconds: 100), () {
        _pageController.jumpToPage(widget.firstItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Meals.isEmpty) {
      return Center(
          child: CircularProgressIndicator(color: AppColors.basicColor));
    }
    return PageView.builder(
        itemCount: Meals.length,
        controller: _pageController,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: MealCard(
              meal: Meals[index],
            ),
          );
        });
  }
}

//PageController( initialPage: widget.firstItem, viewportFraction: 0.7),
