import 'package:flavoria/AppColors.dart';
import 'package:flavoria/widgets/searchHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Search",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.basicColor,
                      fontSize: 33,
                      fontStyle: FontStyle.italic)),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchScreen(),
          )),
        ],
      ),
    );
  }
}
