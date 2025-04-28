// favorites_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavoria/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class FavoritesService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // دالة لإضافة الوجبة إلى المفضلة
  Future<void> addFavoriteMeal(String mealId, Map<String, dynamic> mealData,
      BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ No user logged in");
      return;
    }
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(mealId)
          .set(mealData);
      showCustomSnackBar(context, 'Meal added to favorites');
      print("Meal added to favorites ✅");
    } catch (e) {
      print("❌ Failed to add meal: $e");
    }
  }

  // دالة للتحقق إذا كانت الوجبة مفضلة أم لا
  Future<bool> checkIfFavorite(String mealId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ No user logged in");
      return false;
    }
    final meal = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(mealId)
        .get();
    print('===================================');
    print(meal.data());
    return meal.exists;
  }

  // دالة لإزالة الوجبة من المفضلة
  Future<void> removeFavoriteMeal(String mealId, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ No user logged in");
      return;
    }
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(mealId)
          .delete();
      showCustomSnackBar(context, 'Meal removed from favorites');
      print("Meal removed from favorites ✅");
    } catch (e) {
      print("❌ Failed to remove meal: $e");
    }
  }
}
