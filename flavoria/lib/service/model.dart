import 'package:flutter/material.dart';

class MealModel {
  String Image;
  String Name;
  String Id;
  String Description;
  Map<String, String> Ingredients;
  String Video;

  MealModel(
      {required this.Image,
      required this.Name,
      required this.Id,
      required this.Description,
      required this.Ingredients,
      required this.Video});
}

class ingerdientsModel {
  String image;
  String name;
  Color color;
  final bool isNetwork;

  ingerdientsModel(
      {required this.image,
      required this.color,
      required this.name,
      required this.isNetwork});
}
