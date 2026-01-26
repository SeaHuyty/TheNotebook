import 'package:the_notebook/core/database/database.dart';

class TagModel {
  final int? id;
  final String name;

  const TagModel({this.id, required this.name});

  factory TagModel.fromDrift(Tag tag) {
    return TagModel(name: tag.title, id: tag.id);
  }
}
