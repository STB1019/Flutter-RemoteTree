import 'package:flutter/material.dart';

Widget generateMyAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
          color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(12.0),
    )),
    centerTitle: true,
  );
}
