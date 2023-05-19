import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.image});

  final String? image;

  Widget _buildPlaceHolder(BuildContext context) {
    return const SizedBox(
      width: 150,
      height: 150,
      child: Icon(
        Icons.camera_alt_outlined,
        size: 64,
      ),
    );
  }

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
                errorWidget: (context, url, error) =>
                    _buildPlaceHolder(context))
            : _buildPlaceHolder(context));
  }
}
