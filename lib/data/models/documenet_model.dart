import 'dart:convert';

class DocumentModel {
  final int? id;
  final String? name;
  final String? category;
  final String? path;
  final String? createdAt;
  DocumentModel({
    this.id,
    this.name,
    this.category,
    this.path,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'path': path,
      'createdAt': createdAt,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id']?.toInt(),
      name: map['name'],
      category: map['category'],
      path: map['path'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));
}
