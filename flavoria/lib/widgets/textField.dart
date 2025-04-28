import 'package:flavoria/AppColors.dart';
import 'package:flutter/material.dart';

class TextfieldWidget extends StatefulWidget {
  TextEditingController controller;
  String hint;
  bool password;
  TextfieldWidget(
      {super.key,
      required this.controller,
      required this.hint,
      required this.password});

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.password,
      cursorColor: AppColors.basicColor,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.basicColor)),
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 192, 191, 191))),
          hintText: widget.hint,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 113, 113, 113))),
    );
  }
}
