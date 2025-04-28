import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/searchResults.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/meal_card.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  List<ingerdientsModel> categories = [];

  Categories({super.key, required this.categories});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<MealModel> searchList = [];
  Future _fetchData(String query) async {
    if (query.isEmpty) return; // إذا كان النص فارغًا، لا نقوم بالبحث
    searchList = await request(Type: 'filter.php?c=${query.trim()}');
    print(searchList);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        return GestureDetector(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(
                  color: AppColors.basicColor, // ممكن تغيّري اللون لو حابة
                ),
              ),
            );
            await _fetchData(category.name);
            Navigator.pop(context);
            Navigator.push(
                context,
                createScaleRoute(Searchresults(
                    result: category.name, listOfresults: searchList)));
          },
          child: Card(
            color: AppColors.basicColor,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text(category.name,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      )),
                ),
                Spacer(),
                Image.network(
                  category.image,
                  width: 50,
                  //height: 200,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
