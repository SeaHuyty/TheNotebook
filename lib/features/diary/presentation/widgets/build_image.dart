import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final String imagePath;

  const ImageWidget({super.key, required this.imagePath});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool? isLandscape;

  @override
  void initState() {
    super.initState();
    // loadImageOrientation();
  }

  // Future<void> loadImageOrientation() async {
  //   final bytes = await File(widget.imagePath).readAsBytes();
  //   final image = await decodeImageFromList(bytes);
  //   setState(() {
  //     isLandscape = image.width > image.height;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (isLandscape == null) {
    //   return SizedBox(
    //     height: 150,
    //   );
    // }

    // Check imagePath type here
    if (widget.imagePath.startsWith('/images/')) {
      return Image.asset(
        widget.imagePath,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Image not found')),
          );
        },
      );
    } else if (widget.imagePath.startsWith('blob:') || widget.imagePath.startsWith('http')) {
      // For blob URLs (web) and network URLs
      return Image.network(
        widget.imagePath,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Image not found')),
          );
        },
      );
    } else {
      // For Images from device storage (mobile only)
      return Image.file(
        File(widget.imagePath),
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Image not found')),
          );
        },
      );
    }
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';


// Widget buildImage(String imagePath) {
//   final isLandscape = size.width > size.height;
//   if (imagePath.startsWith('/images/')) {
//     return AspectRatio(
//       aspectRatio: isLandscape ? 1080/566 : ,
//       child: Image.asset(
//         imagePath,
//         height: 150,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return const SizedBox(
//             height: 100,
//             child: Center(child: Text('Image not found')),
//           );
//         },
//       ),
//     );
//   } else if (imagePath.startsWith('blob:') || imagePath.startsWith('http')) {
//     // For blob URLs (web) and network URLs
//     return Image.network(
//       imagePath,
//       height: 150,
//       width: double.infinity,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         return const SizedBox(
//           height: 100,
//           child: Center(child: Text('Image not found')),
//         );
//       },
//     );
//   } else {
//     // For Images from device storage (mobile only)
//     return Image.file(
//       File(imagePath),
//       height: 150,
//       width: double.infinity,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         return const SizedBox(
//           height: 100,
//           child: Center(child: Text('Image not found')),
//         );
//       },
//     );
//   }
// }