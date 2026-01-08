import 'package:flutter/material.dart';

class DiaryTimelineWidget extends StatelessWidget {
  final Widget child;
  final Color circleColor;
  final int dayNumber;
  final bool showLineBelow;

  const DiaryTimelineWidget({
    super.key,
    required this.child,
    required this.dayNumber,
    this.circleColor = Colors.blueAccent,
    this.showLineBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              // Circle
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              // Line below circle - extends to match content height
              if (showLineBelow)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 1.5,
                    color: Colors.grey.shade400,
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLineBelow ? 20 : 0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
