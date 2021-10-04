import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

var buttonStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: const Color.fromRGBO(8, 146, 208, 1));

Container button(
  String text,
) {
  return Container(
    // margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    decoration: buttonStyle,
    child: Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
  );
}
