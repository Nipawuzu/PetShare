import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.image});

  final String? image;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: image != null
          ? CachedNetworkImage(
              imageUrl: image!,
              fit: BoxFit.fitWidth,
            )
          : const SizedBox(
              width: 150,
              height: 150,
              child: Icon(
                Icons.camera_alt_outlined,
                size: 64,
              ),
            ),
    );
  }
}
