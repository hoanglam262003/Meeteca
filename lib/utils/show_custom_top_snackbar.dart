import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomTopSnackbar({
  required String title,
  required String content,
}) {
  Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          style: TextStyle(
            color: Colors.white
          ),
        ),
        messageText: Text(
          content,
          style: TextStyle(
              color: Colors.white
          ),
        ),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        borderRadius: 10,
        duration: Duration(seconds: 2),
        icon: Container(
          margin: EdgeInsets.only(left: 8, right: 20),
            child: Image.asset(
              'assets/images/logo.png',
              width: 70,
              height: 70,
            ),
          ),
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4), // Shadow position (x, y)
            ),
          ],
        ),
      );
  }