import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.firstText,
      required this.secondText,
      this.isFirstTextInBold = false,
      this.firstTextColor = Colors.black,
      this.secondTextColor = Colors.black,
      this.textScaleFactor = 1.0,
      this.textAlign,
      this.paddingSize = 4.0});
  final String firstText, secondText;
  final bool isFirstTextInBold;
  final Color firstTextColor;
  final Color secondTextColor;
  final double textScaleFactor;
  final TextAlign? textAlign;
  final double paddingSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingSize),
      child: Text.rich(
        TextSpan(
            text: firstText,
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight:
                  isFirstTextInBold ? FontWeight.bold : FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: secondText,
                style: TextStyle(
                  fontFamily: "Quicksand",
                  color: secondTextColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ]),
        textScaleFactor: textScaleFactor,
        textAlign: textAlign,
      ),
    );
  }
}
