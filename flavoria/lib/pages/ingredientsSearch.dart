import 'package:flavoria/AppColors.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/img_nameIngredients.dart';

import 'package:flavoria/widgets/searchBar.dart';
import 'package:flutter/material.dart';

class IngredientsSearch extends StatefulWidget {
  IngredientsSearch({super.key});

  @override
  State<IngredientsSearch> createState() => _IngredientsSearchState();
}

class _IngredientsSearchState extends State<IngredientsSearch> {
  List<ingerdientsModel> ingredientsList = [];
  List<ingerdientsModel> filteredList = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch_ingerdients();
  }

  Future fetch_ingerdients() async {
    ingredientsList =
        await ing_request(Type: 'list.php?i=list', list_of: 'meals');
    filteredList = ingredientsList;
    setState(() {});
  }

  List<MealModel> searchList = [];
  Future _fetchData(String query) async {
    if (query.isEmpty) return; // إذا كان النص فارغًا، لا نقوم بالبحث
    searchList = await request(Type: 'filter.php?i=${query.trim()}');
    print(searchList);
    setState(() {});
  }

  void handleSearch(String query) {
    _fetchData(query);
    setState(() {
      filteredList = ingredientsList
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void handleSubmit(String query) {
    // ممكن تضيفي هنا حاجة عند الضغط على زر البحث لو حبيتي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: ingredientsList.isEmpty
          ? Center(
              child: CircularProgressIndicator(color: AppColors.basicColor))
          : Column(
              children: [
                const SizedBox(height: 16),
                Text("Search by Ingredients",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.basicColor,
                        fontSize: 20,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomSearchWidget(
                    searchController: _searchController,
                    onChanged: (handleSearch),
                    onSubmitted: handleSubmit,
                    searchResult: '',
                    searchList:
                        searchList, // ممكن تبعتي قائمة عند الضغط على زر البحث
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final ingredient = filteredList[index];
                      return ImgNameingredients(ingredient: ingredient);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
