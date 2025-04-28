import 'package:flavoria/service/model.dart';
import 'package:flavoria/widgets/img_nameIngredients.dart';
import 'package:flutter/material.dart';

class IngredientsList extends StatelessWidget {
  IngredientsList({super.key});

  List<ingerdientsModel> ingredients = [
    ingerdientsModel(
        name: 'Egg',
        image: 'assets/egg.png',
        color: Color(0xFFF5E4D3),
        isNetwork: false),
    ingerdientsModel(
        name: 'Avocado',
        image: 'assets/avocado.png',
        color: Color(0xFFD6F5C4),
        isNetwork: false),
    ingerdientsModel(
        name: 'Chicken',
        image: 'assets/chicken.png',
        color: Color(0xFFFADDE2),
        isNetwork: false),
    ingerdientsModel(
        name: 'Cheese',
        image: 'assets/cheese.png',
        color: Color(0xFFFFF39C),
        isNetwork: false),
    ingerdientsModel(
        name: 'Apple',
        image: 'assets/apple.png',
        color: Color(0xFFF0797B),
        isNetwork: false),
    ingerdientsModel(
        name: 'Pasta',
        image: 'assets/pasta.png',
        color: Color(0xFFE4BD94),
        isNetwork: false),
    ingerdientsModel(
        name: 'Banana',
        image: 'assets/banana.png',
        color: Color(0xFFFFF4B5),
        isNetwork: false),
    ingerdientsModel(
        name: 'Honey',
        image: 'assets/honey.png',
        color: Color(0xFFFDCD77),
        isNetwork: false),
    ingerdientsModel(
        name: 'Cheese',
        image: 'assets/cheese.png',
        color: Color(0xFFF5E4D3),
        isNetwork: false),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, index) {
            final ingerident = ingredients[index];
            return ImgNameingredients(ingredient: ingerident);
          }),
    );
  }
}
