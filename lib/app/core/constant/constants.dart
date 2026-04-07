// import 'dart:io';


// import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

BuildContext? globleContext;

  String maskName(String name) {
  if (name.trim().isEmpty) return "";

  return name
      .split(' ')
      .map((word) {
        if (word.isEmpty) return "";
        if (word.length == 1) return word; // single letter safe
        return word[0] + '*' * (word.length - 1);
      })
      .join(' ');
}

String formatCount(int count) {
  if (count < 1000) {
    return count.toString();
  } else if (count < 1000000) {
    final value = count / 1000;
    return value % 1 == 0
        ? '${value.toInt()}K'
        : '${value.toStringAsFixed(1)}K';
  } else if (count < 1000000000) {
    final value = count / 1000000;
    return value % 1 == 0
        ? '${value.toInt()}M'
        : '${value.toStringAsFixed(1)}M';
  } else {
    final value = count / 1000000000;
    return value % 1 == 0
        ? '${value.toInt()}B'
        : '${value.toStringAsFixed(1)}B';
  }
}
