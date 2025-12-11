import 'package:flutter/material.dart';
import '../../features/diary/presentation/pages/diary.dart';
import '../../features/list/presentation/pages/list_page.dart';

class AppDrawer extends StatelessWidget {
  final String currentPage;

  const AppDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey
                )
              )
            ),
            child: Text('Hello Tengyi', style: TextStyle(fontSize: 22),),
          ),
          ListTile(
            title: Text('Diary'),
            selected: currentPage == 'diary',
            onTap: () {
              if (currentPage != 'diary') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Diary()),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: Text('List'),
            selected: currentPage == 'list',
            onTap: () {
              if (currentPage != 'list') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TodoPage()),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(title: Text('Setting')),
        ],
      ),
    );
  }
}