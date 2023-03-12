import 'package:flutter/material.dart';
import 'package:pet_share/all_views.dart';
import 'package:pet_share/theme.dart';

void main() {
  runApp(const PetShare());
}

class PetShare extends StatelessWidget {
  const PetShare({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Scaffold(
        body: SafeArea(child: AllViews()),
      ),
    );
  }
}
