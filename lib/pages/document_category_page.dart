import 'package:flutter/material.dart';

import '../data/datasource/document_local_datasource.dart';
import '../data/models/documenet_model.dart';
import 'latest_documents_page.dart';

class DocumentCategoryPage extends StatefulWidget {
  final String categoryTitle;
  const DocumentCategoryPage({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<DocumentCategoryPage> createState() => _DocumentCategoryPageState();
}

class _DocumentCategoryPageState extends State<DocumentCategoryPage> {
  List<DocumentModel> documents = [];

  loadData() async {
    documents = await DocumentLocalDatasource.instance
        .getDocumentByCategory(widget.categoryTitle);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document ${widget.categoryTitle}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: documents.isEmpty
                ? Center(child: Text("${widget.categoryTitle} is empty",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),))
                : LatestDocumentsPage(
                    documents: documents,
                  ),
          ),
        ],
      ),
    );
  }
}
