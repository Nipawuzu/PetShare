import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.firstText,
    required this.secondText,
    this.isFirstTextInBold = false,
    this.secondTextColor = Colors.black,
  });
  final String firstText, secondText;
  final bool isFirstTextInBold;
  final Color secondTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text.rich(TextSpan(
          text: firstText,
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 15,
            fontWeight: isFirstTextInBold ? FontWeight.bold : FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: secondText,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 15,
                color: secondTextColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ])),
    );
  }
}
