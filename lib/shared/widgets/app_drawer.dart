import 'package:flutter/material.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_page.dart';
import 'package:the_notebook/features/setting/presentation/pages/setting.dart';

class AppDrawer extends StatelessWidget {
  final String currentPage;

  const AppDrawer(
      {super.key,
      required this.currentPage,});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: const Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: const Text('Hello Tengyi', style: TextStyle(fontSize: 22)),
          ),
          ListTile(
            leading: Icon(Icons.book_outlined),
            title: const Text('Notebook'),
            selected: currentPage == 'notebook',
            onTap: () {
              if (currentPage != 'notebook') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotebookPage(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: const Text('Setting'),
            selected: currentPage == 'setting',
            onTap: () {
              if (currentPage != 'setting') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingPage(
                          )),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text('Share with friends'),
          ),
          ListTile(
            leading: Icon(Icons.star_border_rounded),
            title: Text('Rate the app'),
          ),
          ListTile(
            leading: Icon(Icons.contact_support_outlined),
            title: Text('Contact the support team'),
          ),
        ],
      ),
    );
  }
}
