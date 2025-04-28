import 'package:flavoria/AppColors.dart'; // استيراد ملف الألوان الخاص بالتطبيق
import 'package:flavoria/pages/ingredientsSearch.dart';
import 'package:flavoria/pages/searchResults.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/categories.dart';
import 'package:flavoria/widgets/ingredientsList.dart';
import 'package:flavoria/widgets/searchBar.dart';
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر الأساسية لإنشاء الواجهات

// تعريف صفحة البحث كـ StatefulWidget لتحديث واجهة المستخدم عند إدخال نص جديد
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// الحالة الخاصة بصفحة البحث التي تتغير بناءً على إدخال المستخدم
class _SearchScreenState extends State<SearchScreen> {
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

  List<ingerdientsModel> categoriesList = [];
  Future fetch_categories() async {
    categoriesList =
        await ing_request(Type: 'categories.php', list_of: 'categories');
    print("Categories List: ${categoriesList.length}");
    if (mounted) {
      setState(() {});
    }
  }

  // دالة لتحديث قائمة نتائج البحث عند إدخال المستخدم للنص
  void _updateSearchResults(String query) {
    fetchSearch(query); // جلب البيانات من الـ API بناءً على النص المدخل

    setState(() {
      // تصفية القائمة بناءً على النص المدخل
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList(); // الاحتفاظ فقط بالعناصر التي تحتوي على النص المدخل
    });
  }

  @override
  void initState() {
    fetch_categories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تعيين لون الخلفية إلى الأبيض
      body: Padding(
        padding: EdgeInsets.all(0.0), // إضافة مسافة حول العناصر داخل الصفحة
        child: Stack(
          // استخدام Stack لعرض عناصر فوق بعضها
          children: [
            ListView(
              // crossAxisAlignment:
              //     CrossAxisAlignment.start, // محاذاة المحتويات إلى الجهة اليسرى
              children: [
                // عنصر البحث بتصميم مخصص
                CustomSearchWidget(
                  searchController: _searchController,
                  onChanged: _updateSearchResults,
                  onSubmitted: (query) {
                    // تنفيذ الكود عند الضغط على زر البحث
                  },
                  searchResult: _searchResult,
                  searchList: searchList,
                ),

                const SizedBox(
                    height: 10), // إضافة مسافة بين شريط البحث وقائمة الاقتراحات

                // عرض الرسالة "Search by Ingredients"
                Row(
                  children: [
                    Text("Search by Ingredients",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.basicColor,
                            fontSize: 20,
                            fontStyle: FontStyle.italic)),
                    Spacer(),
                    GestureDetector.new(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IngredientsSearch()));
                      },
                      child: Text('VIEW ALL',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: AppColors.basicColor,
                              fontSize: 14,
                              decorationColor: AppColors.basicColor,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
                IngredientsList(),
                Text("Most Popular Categories",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.basicColor,
                        fontSize: 20,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Categories(
                  categories: categoriesList,
                )
              ],
            ),

            // قائمة الاقتراحات التي تظهر فوق باقي المحتوى
            if (_filteredItems.isNotEmpty && _searchController.text.isNotEmpty)
              Positioned(
                top: 50, // تحديد مكان ظهور قائمة الاقتراحات
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems
                        .length, // تحديد عدد العناصر في القائمة بناءً على البحث
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredItems[
                            index]), // عرض اسم العنصر داخل القائمة
                        onTap: () {
                          final selectedItem = _filteredItems[index];

                          final filtered = searchList
                              .where((meal) =>
                                  meal.Name.toLowerCase() ==
                                  selectedItem.toLowerCase())
                              .toList();
                          setState(() {
                            _searchController.text = _filteredItems[
                                index]; // تعيين العنصر المختار داخل شريط البحث
                            _searchResult = _filteredItems[
                                index]; // تخزين العنصر المحدد كنتيجة بحث
                            _filteredItems =
                                []; // إخفاء قائمة الاقتراحات بعد الاختيار
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Searchresults(
                                          result: '$_searchResult',
                                          listOfresults: filtered,
                                        )));
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
