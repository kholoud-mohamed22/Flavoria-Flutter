import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/searchResults.dart';
import 'package:flavoria/service/model.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomSearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final String searchResult;
  final List<MealModel> searchList;

  CustomSearchWidget({
    required this.searchController,
    required this.onChanged,
    required this.onSubmitted,
    required this.searchResult,
    required this.searchList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        cursorColor: AppColors.basicColor,
        controller: searchController,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        onSubmitted: (query) {
          onSubmitted(query);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Searchresults(
                result: query,
                listOfresults: searchList,
              ),
            ),
          );
        },
        decoration: InputDecoration(
          hintText: "Search Recipes",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: const Icon(Icons.search, color: AppColors.basicColor),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
