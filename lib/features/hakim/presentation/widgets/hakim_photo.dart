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
    final photo = url.isEmpty
        ? Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.person, size: 36, color: Colors.grey),
            ),
          )
        : Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.person, size: 36, color: Colors.grey),
              ),
            ),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Colors.grey.shade100,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          );

    // Kalau width & height diberi, ukuran dipaksa kotak.
    // Kalau hanya salah satu, rasio dipertahankan.
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
