import 'package:flutter/material.dart';

class PickButton extends StatelessWidget {
  const PickButton(
      {super.key,
      this.category,
      this.size,
      this.color,
      this.onPressed,
      this.imageScale,
      required this.image});

  final String? category;
  final double? size;
  final Color? color;
  final double? imageScale;
  final void Function()? onPressed;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        fillColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            side: BorderSide(width: 2, color: Colors.grey.shade200)),
        child: Column(
          children: [
            Expanded(
              child: Transform.scale(
                scale: imageScale ?? 1,
                child:
                    Padding(padding: const EdgeInsets.all(2.0), child: image),
              ),
            ),
            if (category != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  category!,
                ),
              ),
          ],
        ));
  }
}
