import 'dart:io';

import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../core/spaces.dart';
import '../data/models/documenet_model.dart';

class DetailDocumentPage extends StatefulWidget {
  final DocumentModel document;
  const DetailDocumentPage({
    super.key,
    required this.document,
  });

  @override
  State<DetailDocumentPage> createState() => _DetailDocumentPageState();
}

class _DetailDocumentPageState extends State<DetailDocumentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Document'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.document.name!,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SpaceHeight(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.document.category!,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.primary,
                ),
              ),
              Text(
                widget.document.createdAt!,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              width: double.infinity,
              File(widget.document.path!),
              fit: BoxFit.contain,
              colorBlendMode: BlendMode.colorBurn,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          const SpaceHeight(20),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this document?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement delete functionality
                            //if result is true, delete document and navigate back
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }
}