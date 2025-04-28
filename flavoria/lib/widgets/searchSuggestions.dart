import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> filteredItems;
  final Function(String) onTap;

  const SearchSuggestions({
    required this.filteredItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredItems[index]),
            onTap: () => onTap(filteredItems[index]),
          );
        },
      ),
    );
  }
}
