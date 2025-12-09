import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_drawer.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: AppDrawer(currentPage: 'List'),
      body: Center(child: Text('List Page - Coming Soon')),
    );
  }
}
