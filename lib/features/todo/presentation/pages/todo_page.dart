import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_drawer.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: AppDrawer(currentPage: 'todo'),
      body: Center(child: Text('Todo Page - Coming Soon')),
    );
  }
}
