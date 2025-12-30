enum NotebookType { life, work, sport }

class Notebook {
  final String title;
  final NotebookType category;

  Notebook({
    required this.title,
    required this.category
  });
}