import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/notebook/presentation/pages/notebook_drawer.dart';
import 'package:the_notebook/features/setting/presentation/pages/setting.dart';

class AppDrawer extends ConsumerStatefulWidget {
  final String currentPage;

  const AppDrawer({
    super.key,
    required this.currentPage,
  });

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  late final userRepo = ref.read(userRepositoryProvider);
  late int? defaultNotebook;

  @override
  void initState() {
    loadDefaultNotebook();
    super.initState();
  }

  void loadDefaultNotebook() async {
    defaultNotebook = await userRepo.getDefaultNotebook();
  }

  void openNotebookDrawer(BuildContext context) {
    Navigator.pop(context);
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: const NotebookDrawer(),
            ),
          );
        });
  }

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
            subtitle: Row(
              children: [Text('Switch'), Icon(Icons.arrow_drop_down)],
            ),
            selected: widget.currentPage == 'notebook',
            onTap: () {
              if (widget.currentPage != 'notebook') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryPage(
                      notebookId: defaultNotebook!,
                    ),
                  ),
                );
              } else {
                openNotebookDrawer(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: const Text('Setting'),
            selected: widget.currentPage == 'setting',
            onTap: () {
              if (widget.currentPage != 'setting') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
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
