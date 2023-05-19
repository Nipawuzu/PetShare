import 'package:flutter/material.dart';

class FilteringCategory extends StatelessWidget {
  const FilteringCategory({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: const Color.fromARGB(255, 187, 187, 187),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: Text(
            category,
            textScaleFactor: 1.2,
          )),
    );
  }
}
