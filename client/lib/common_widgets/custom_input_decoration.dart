import 'package:flutter/material.dart';

InputDecoration customInputDecoration(String text) {
  return InputDecoration(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        const SizedBox(width: 1),
        const Text('*', style: TextStyle(color: Colors.red)),
      ],
    ),
  );
}
