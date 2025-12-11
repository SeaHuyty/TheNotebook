import 'package:flutter/material.dart';

class TaskStat extends StatelessWidget {
  const TaskStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.purple,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TOTAL",
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),

            Text("11", style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
