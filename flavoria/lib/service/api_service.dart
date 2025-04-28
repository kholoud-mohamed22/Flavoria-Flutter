import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flavoria/service/model.dart';
import 'package:flutter/material.dart';

final dio = Dio();

const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

Future<Map<String, dynamic>> fetchData(String type) async {
  try {
    Response response = await dio.get('$baseUrl$type');
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return {};
  }
}

Future<List<MealModel>> request({String Type = ''}) async {
  List<MealModel> mealsList = [];

  Map<String, dynamic> jsonData = await (fetchData(Type));

  // التحقق من وجود "meals" في jsonData وإذا كانت null أو فارغة
  if (jsonData['meals'] != null) {
    List<dynamic> meals = jsonData['meals'];

    for (var meal in meals) {
      Map<String, String> ingredients = {};
      for (int i = 1; i <= 20; i++) {
        String ingredientKey = 'strIngredient$i';
        String measureKey = 'strMeasure$i';

        if (meal[ingredientKey] != null &&
            meal[ingredientKey].toString().isNotEmpty) {
          ingredients[meal[ingredientKey]] = meal[measureKey] ?? "";
        }
      }
      MealModel mealmodel = MealModel(
          Image: meal['strMealThumb'],
          Name: meal['strMeal'],
          Id: meal['idMeal'],
          Description: meal['strInstructions'] ?? '',
          Ingredients: ingredients,
          Video: meal['strYoutube'] ?? '');
      mealsList.add(mealmodel);
    }
  } else {
    print("No meals found in the response");
    // يمكنك إرجاع قائمة فارغة أو التعامل مع الحالة كما تراه مناسبًا
  }

  return mealsList;
}

Future<List<ingerdientsModel>> ing_request(
    {required String Type, required String list_of}) async {
  List<ingerdientsModel> ingerdientsList = [];
  Map<String, dynamic> jsonData = await (fetchData(Type));

  if (jsonData['$list_of'] != null) {
    List<dynamic> meals = jsonData['$list_of'];

    for (var meal in meals) {
      if (list_of == 'meals') {
        ingerdientsModel model = ingerdientsModel(
            image:
                'https://www.themealdb.com/images/ingredients/${meal['strIngredient']}-small.png',
            color: Color(0xFFF8F1E1),
            name: meal['strIngredient'] ?? '',
            isNetwork: true);
        ingerdientsList.add(model);
      } else if (list_of == 'categories') {
        ingerdientsModel model = ingerdientsModel(
            image: meal['strCategoryThumb'],
            color: Color(0xFFF8F1E1),
            name: meal['strCategory'],
            isNetwork: true);
        ingerdientsList.add(model);
      }
    }
  } else {
    print('error');
  }
  return ingerdientsList;
}
