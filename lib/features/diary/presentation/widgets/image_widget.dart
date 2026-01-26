import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_notebook/core/models/diary_image.dart';

class ImageWidget extends StatefulWidget {
  final DiaryImageModel image;
  final double? height;

  const ImageWidget({super.key, required this.image, this.height});

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

    final double imageHeight = widget.height ?? (isLandscape ? 170 : 220);
    final double? imageWidth =
        isLandscape ? null : (widget.height != null ? null : 170);

    if (widget.image.imagePath.startsWith('/images/')) {
      return SizedBox(
        width: imageWidth,
        height: imageHeight,
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
        width: imageWidth,
        height: imageHeight,
        child: AspectRatio(
          aspectRatio: isLandscape ? 760 / 566 : 1080 / 1350,
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
        width: imageWidth,
        height: imageHeight,
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
