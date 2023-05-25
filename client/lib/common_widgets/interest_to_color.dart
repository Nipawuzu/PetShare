import 'package:flutter/material.dart';

Color interestToColor(int applicationsCount) {
  if (applicationsCount <= 5) {
    return Colors.green.shade200;
  }

  if (applicationsCount <= 10) {
    return Colors.green.shade400;
  }

  if (applicationsCount <= 20) {
    return Colors.yellow.shade500;
  }

  if (applicationsCount <= 30) {
    return Colors.orange.shade500;
  }

  return Colors.red.shade400;
}
