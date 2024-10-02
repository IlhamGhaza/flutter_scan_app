import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_scan_app/pages/home_page.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import '../core/colors.dart';
import '../core/spaces.dart';
import '../data/datasource/document_local_datasource.dart';
import '../data/models/documenet_model.dart';

class EditDocumentPage extends StatefulWidget {
  final DocumentModel document;
  const EditDocumentPage({super.key, required this.document});

  @override
  State<EditDocumentPage> createState() => _EditDocumentPageState();
}

class _EditDocumentPageState extends State<EditDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _category;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _name = widget.document.name ?? '';
    _category = widget.document.category ?? '';
    _images = widget.document.path ?? [];
  }

  Future<void> _pickImages() async {
    final documentOptions = DocumentScannerOptions();

    try {
      // Start the scanning process
      final documentScanner = DocumentScanner(options: documentOptions);
      DocumentScanningResult result = await documentScanner.scanDocument();

      setState(() {
        _images.addAll(result.images); // Add the scanned image paths to the list
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to scan document'),backgroundColor: Colors.red,),
      );
    }
  }

  Future<void> _saveDocument() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Update the document in the local database
      final updatedDocument = DocumentModel(
        id: widget.document.id,
        name: _name,
        category: _category,
        path: _images,
        createdAt: widget.document.createdAt, // Preserve original creation date
      );

      await DocumentLocalDatasource.instance.saveDocument(updatedDocument);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document updated successfully'),
        backgroundColor: AppColors.primary,),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Document'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument,
            color: AppColors.primary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Document Name'),
                onSaved: (value) {
                  _name = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a document name';
                  }
                  return null;
                },
              ),
              const SpaceHeight(16),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (value) {
                  _category = value ?? '';
                },
              ),
              const SpaceHeight(16),
              const Text('Images'),
              const SpaceHeight(8),
              Wrap(
                spacing: 8.0,
                children: _images.map((imagePath) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(
                        File(imagePath),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _images.remove(imagePath);
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SpaceHeight(16),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Scan Document'),
              ),
              const SpaceHeight(16),
              ElevatedButton(
                onPressed: _saveDocument,
                child: const Text('Save Document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
