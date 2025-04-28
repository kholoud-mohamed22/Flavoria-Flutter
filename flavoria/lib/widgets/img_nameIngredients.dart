import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/searchResults.dart';
import 'package:flavoria/service/api_service.dart';
import 'package:flavoria/service/model.dart';
import 'package:flutter/material.dart';

class ImgNameingredients extends StatefulWidget {
  final ingerdientsModel ingredient;
  ImgNameingredients({super.key, required this.ingredient});

  @override
  State<ImgNameingredients> createState() => _ImgNameingredientsState();
}

class _ImgNameingredientsState extends State<ImgNameingredients> {
  List<MealModel> searchList = [];
  Future _fetchData(String query) async {
    if (query.isEmpty) return; // إذا كان النص فارغًا، لا نقوم بالبحث
    searchList = await request(Type: 'filter.php?i=${query.trim()}');
    print(searchList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _fetchData(widget.ingredient.name);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Searchresults(
                    result: widget.ingredient.name,
                    listOfresults: searchList)));
      },
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.ingredient.color, // لون خلفية الدائرة
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: widget.ingredient.isNetwork
                    ? Image.network(
                        widget.ingredient.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // الصورة تحميلت
                          } else {
                            // لا نعرض أي شيء أثناء تحميل الصورة
                            return Container(color: widget.ingredient.color);
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                              color: widget.ingredient
                                  .color); // لو في خطأ نعرض اللون فقط
                        },
                      )
                    : Image.asset(
                        widget.ingredient.image,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            SizedBox(height: 6),
            Flexible(
              child: Text(
                widget.ingredient.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // يحط "..." لو الاسم طويل
                maxLines: 2, // لو اسم طويل يخليه سطرين
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.basicColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
