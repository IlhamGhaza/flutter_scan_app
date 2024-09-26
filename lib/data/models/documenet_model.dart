import 'dart:convert';

class DocumentModel {
  final int? id;
  final String? name;
  final String? category;
  final List<String>? path;
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
      // Jika path tidak null, konversi List<String> ke string bergabung (separated by ',')
      'path': path != null ? path!.join(',') : null,
      'createdAt': createdAt,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id']?.toInt(),
      name: map['name'],
      category: map['category'],
      // Konversi path yang sebelumnya disimpan sebagai string bergabung kembali ke List<String>
      path: map['path'] != null ? (map['path'] as String).split(',') : [],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));
}
