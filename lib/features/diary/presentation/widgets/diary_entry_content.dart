import 'package:flutter/material.dart';

class DiaryEntryContent extends StatelessWidget {
  final String date;
  final String content;
  final String? imageUrl;

  const DiaryEntryContent({
    super.key,
    required this.date,
    required this.content,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl != null) ...[
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text('Image not found')),
                );
              },
            ),
          ),
          SizedBox(height: 8),
        ],
        Text(date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
