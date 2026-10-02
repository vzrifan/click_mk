import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const kHakimPhotoAspect = 421 / 631;

class HakimPhoto extends StatelessWidget {
  const HakimPhoto({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  final String url;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget photo;
    if (url.isEmpty) {
      photo = Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.person, size: 36, color: Colors.grey),
        ),
      );
    } else {
      photo = CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        cacheKey: url,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (_, _) => Container(color: Colors.grey.shade100),
        errorWidget: (_, _, _) => Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(Icons.person, size: 36, color: Colors.grey),
          ),
        ),
      );
    }

    if (width != null && height != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(width: width, height: height, child: photo),
      );
    }
    if (width != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: width,
          height: width! / kHakimPhotoAspect,
          child: photo,
        ),
      );
    }
    if (height != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: height! * kHakimPhotoAspect,
          height: height,
          child: photo,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(aspectRatio: kHakimPhotoAspect, child: photo),
    );
  }
}
