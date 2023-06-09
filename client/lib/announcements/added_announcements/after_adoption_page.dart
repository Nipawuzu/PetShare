import 'package:flutter/material.dart';
import 'package:pet_share/announcements/details/view.dart';

class AfterAdoptionPage extends StatelessWidget {
  const AfterAdoptionPage(
      {super.key, required this.message, required this.suceed});

  final String message;
  final bool suceed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                suceed ? "images/success.png" : "images/fail.png",
                fit: BoxFit.fitWidth,
                width: 150.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
            TextWithBasicStyle(
              text: message,
              align: TextAlign.center,
              textScaleFactor: 2,
            ),
            TextButton(
              onPressed: () => {
                Navigator.pop(context),
              },
              child: const TextWithBasicStyle(
                text: "Wróć do widoku głównego",
                align: TextAlign.center,
                textScaleFactor: 1.4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
