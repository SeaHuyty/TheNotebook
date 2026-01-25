import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_notebook/core/models/diary_image.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';

class ImageGalleryWidget extends StatelessWidget {
  final List<XFile> images;
  final List<bool> isLandscape;
  final bool showRemoveButton;
  final Function(int)? onRemove;
  final double height;

  const ImageGalleryWidget({
    super.key,
    required this.images,
    required this.isLandscape,
    this.showRemoveButton = false,
    this.onRemove,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    final hasPortrait = isLandscape.contains(false);
    final imageHeight = hasPortrait ? 220.0 : height;

    return SizedBox(
      height: imageHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ImageWidget(
                    image: DiaryImageModel(
                      imagePath: images[index].path,
                      isLandscape: isLandscape[index],
                    ),
                    height: imageHeight,
                  ),
                ),
                if (showRemoveButton && onRemove != null)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => onRemove!(index),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
