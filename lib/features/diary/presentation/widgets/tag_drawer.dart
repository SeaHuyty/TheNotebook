import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/features/diary/domain/tag.dart';

class TagDrawer extends StatefulWidget {
  const TagDrawer({
    super.key,
  });

  @override
  State<TagDrawer> createState() => _TagDrawerState();
}

class _TagDrawerState extends State<TagDrawer> {
  final TagRepository _tagRepo = TagRepository();
  List<Tag> tags = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTags();
  }

  Future<void> loadTags() async {
    final loadedTags = await _tagRepo.getAllTags();
    setState(() {
      tags = loadedTags;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                const SizedBox(width: 10),
                const Text('Tags', style: TextStyle(fontSize: 18)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tags.isEmpty
                      ? const Center(child: Text('No tags available'))
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                          itemCount: tags.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(tags[index].name),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}