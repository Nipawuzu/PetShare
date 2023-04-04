import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.size, required this.image});

  final double size;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SizedBox.square(
          dimension: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image != null
                ? CachedNetworkImage(
                    imageUrl: image!,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.camera_alt_outlined,
                    size: 64,
                  ),
          ),
        ),
      ),
    );
  }
}
