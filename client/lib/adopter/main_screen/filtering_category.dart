import 'package:flutter/material.dart';
import 'package:pet_share/common_widgets/pick_button.dart';

class FilteringCategory extends StatelessWidget {
  const FilteringCategory(
      {super.key,
      this.category,
      this.size,
      required this.image,
      this.onPressed,
      this.picked = false});

  final String? category;
  final double? size;
  final bool picked;
  final Function()? onPressed;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return PickButton(
        category: category,
        color: picked ? Colors.green.shade200 : Colors.grey.shade200,
        image: image,
        onPressed: onPressed);
  }
}
