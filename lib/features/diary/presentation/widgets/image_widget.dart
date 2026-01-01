import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart';

class ImageWidget extends StatefulWidget {
  final DiaryImage image;

  const ImageWidget({super.key, required this.image});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = widget.image.isLandscape;

    // Check imagePath type here
    if (widget.image.imagePath.startsWith('/images/')) {
      return SizedBox(
        width: isLandscape ? null : 170,
        height: isLandscape ? 170 : 220,
        child: AspectRatio(
          aspectRatio: isLandscape ? 1080 / 566 : 1080 / 1350,
          child: Image.asset(
            widget.image.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Image not found')),
              );
            },
          ),
        ),
      );
    } else if (widget.image.imagePath.startsWith('blob:') ||
        widget.image.imagePath.startsWith('http')) {
      // For blob URLs (web) and network URLs
      return SizedBox(
        width: isLandscape ? null : 170,
        height: isLandscape ? 170 : 220,
        child: AspectRatio(
          aspectRatio: isLandscape ? 1080 / 566 : 1080 / 1350,
          child: Image.network(
            widget.image.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Image not found')),
              );
            },
          ),
        ),
      );
    } else {
      // For Images from device storage (mobile only)
      return SizedBox(
        width: isLandscape ? null : 170,
        height: isLandscape ? 170 : 220,
        child: AspectRatio(
          aspectRatio: isLandscape ? 1080 / 566 : 1080 / 1350,
          child: Image.file(
            File(widget.image.imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Image not found')),
              );
            },
          ),
        ),
      );
    }
  }
}
