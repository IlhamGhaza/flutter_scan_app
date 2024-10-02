import 'package:sqflite/sqflite.dart';

import '../models/documenet_model.dart';


class DocumentLocalDatasource {
  DocumentLocalDatasource._init();

  static final DocumentLocalDatasource instance =
      DocumentLocalDatasource._init();

  final String tableDocuments = 'documents';

  static Database? _database;

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableDocuments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      path TEXT,
      category TEXT,
      createdAt TEXT
    )
  ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('documentscan.db');
    return _database!;
  }

  Future<void> saveDocument(DocumentModel document) async {
    final db = await instance.database;

    if (document.id != null) {
      // If document has an ID, update it
      await db.update(
        tableDocuments,
        document.toMap(),
        where: 'id = ?',
        whereArgs: [document.id],
      );
    } else {
      // Otherwise, insert a new document
      await db.insert(tableDocuments, document.toMap());
    }
  }


  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await instance.database;
    final result = await db.query(tableDocuments, orderBy: 'createdAt DESC');
    return result.map((map) => DocumentModel.fromMap(map)).toList();
  }

  Future<List<DocumentModel>> getDocumentByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(tableDocuments,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'createdAt DESC');
    return result.map((map) => DocumentModel.fromMap(map)).toList();
  }
  Future<int> deleteDocument(int id) async {
    final db = await database;
    return await db.delete(
      'documents', // Nama tabel
      where: 'id = ?', // Hapus berdasarkan id
      whereArgs: [id],
    );
  }
}
