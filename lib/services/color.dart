import 'package:flutter/material.dart';

final colorList = [
  const Color(0xffffffff), // classic white
  const Color(0xfff28b81), // light pink
  const Color(0xfff7bd02), // yellow
  const Color(0xfffbf476), // light yellow
  const Color(0xffcdff90), // light green
  const Color(0xffa7feeb), // turquoise
  const Color(0xffcbf0f8), // light cyan
  const Color(0xffafcbfa), // light blue
  const Color(0xffd7aefc), // plum
  const Color(0xfffbcfe9), // misty rose
  const Color(0xffe6c9a9), // light brown
  const Color(0xffe9eaee) // light gray
];

Widget colorSlider(int index) {
  return Container(
    decoration:
        const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
    child: CircleAvatar(
      backgroundColor: colorList[index],
    ),
  );
}
