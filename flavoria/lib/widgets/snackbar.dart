import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Text(
            message,
            style: TextStyle(color: Colors.black),
          )),
        ],
      ),
      backgroundColor: isError
          ? const Color.fromARGB(255, 217, 196, 196)
          : const Color.fromARGB(255, 194, 223, 195),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 3),
    ),
  );
}
