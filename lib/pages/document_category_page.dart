import 'package:flutter/material.dart';
import 'package:flutter_scan_app/pages/latest_document_pages.dart';


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
  // List<DocumentModel> documents = [];

  // loadData() async {
  //   documents = await DocumentLocalDatasource.instance
  //       .getDocumentByCategory(widget.categoryTitle);
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   loadData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document ${widget.categoryTitle}'),
      ),
      body: Column(
        children: [
          Expanded(
              child: LatestDocumentPages(
            // documents: documents,
          )),
        ],
      ),
    );
  }
}
