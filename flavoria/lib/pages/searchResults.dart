import 'package:flavoria/AppColors.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flutter/material.dart';

class Searchresults extends StatefulWidget {
  String result;
  List<MealModel> listOfresults;
  Searchresults({super.key, required this.result, required this.listOfresults});

  @override
  State<Searchresults> createState() => _SearchresultsState();
}

class _SearchresultsState extends State<Searchresults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.result,
          style: TextStyle(
              color: AppColors.basicColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.listOfresults.isEmpty
          ? Center(
              child: CircularProgressIndicator(color: AppColors.basicColor))
          : GridView.builder(
              itemCount: widget.listOfresults.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                childAspectRatio: 0.65, // عرض إلى ارتفاع العنصر
              ),
              itemBuilder: (context, index) {
                return Container(
                    width: 300,
                    height: 350,
                    child: MealCard(meal: widget.listOfresults[index]));
              },
            ),
    );
  }
}
