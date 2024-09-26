import 'dart:io';

import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../core/spaces.dart';
import '../data/models/documenet_model.dart';
import 'detail_document_page.dart';

class LatestDocumentsPage extends StatefulWidget {
  final List<DocumentModel> documents;
  const LatestDocumentsPage({
    super.key,
    required this.documents,
  });

  @override
  State<LatestDocumentsPage> createState() => _LatestDocumentsPageState();
}

class _LatestDocumentsPageState extends State<LatestDocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.documents.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailDocumentPage(
                              document: widget.documents[index],
                            )));
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.documents[index].path!.map((imagePath) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(
                                    imagePath), // Gunakan setiap path dalam daftar path
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.8,
                                colorBlendMode: BlendMode.colorBurn,
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SpaceHeight(4),
                  Text(
                    widget.documents[index].name!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
