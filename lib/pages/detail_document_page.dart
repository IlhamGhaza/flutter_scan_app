import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_app/pages/home_page.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;

import '../core/colors.dart';
import '../core/spaces.dart';
import '../data/datasource/document_local_datasource.dart';
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
  Future<bool> deleteDocument(DocumentModel document) async {
    try {
      // Delete the document from the database
      int deletedRows =
          await DocumentLocalDatasource.instance.deleteDocument(document.id!);

      if (deletedRows > 0) {
        final file = File(document.path!);
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete document'),
        ),
      );
      return false;
    }
  }

  Future<void> saveAsPdf() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(File(widget.document.path!).readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final file =
          File(path.join(selectedDirectory, '${widget.document.name}.pdf'));
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved to ${file.path}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Directory not selected, PDF not saved'),
        ),
      );
    }
  }

  Future<void> saveAsImage() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final file =
          File(path.join(selectedDirectory, '${widget.document.name}.png'));
      await File(widget.document.path!).copy(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved to ${file.path}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Directory not selected, image not saved'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Document'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.document.name ?? '',
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
                    widget.document.category ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    widget.document.createdAt ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SpaceHeight(12),
              //show multi image

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          width: MediaQuery.of(context).size.width * 0.8,
                          File(widget.document.path ?? ''),
                          fit: BoxFit.contain,
                          colorBlendMode: BlendMode.colorBurn,
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  1,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          AppColors.primary.withOpacity(index == 0 ? 1 : 0.3),
                    ),
                  ),
                ),
              ),
              const SpaceHeight(20),
              //save to internal memory
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    ElevatedButton(
                      onPressed: saveAsPdf,
                      child: const Text("Save as PDF"),
                    ),
                    const SpaceHeight(20),
                    const Text('')
                  ]),
                  Column(children: [
                    ElevatedButton(
                      onPressed: saveAsImage,
                      child: const Text("Save as Image"),
                    ),
                    const SpaceHeight(20),
                    InkWell(
                        onTap: () {
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
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      bool deleteSuccess =
                                          await deleteDocument(widget.document);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      if (deleteSuccess) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            'Document deleted successfully',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.green,
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            'Failed to delete document',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
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
                        child: const Text('Delete',
                        style: TextStyle(
                          color: Colors.red
                        ),))
                  ]),
                ],
              ),
              const SpaceHeight(20),
              //delete document
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: const Text('Confirm Delete'),
              //               content: const Text(
              //                   'Are you sure you want to delete this document?'),
              //               actions: <Widget>[
              //                 TextButton(
              //                   onPressed: () {
              //                     Navigator.of(context)
              //                         .pop(); // Close the dialog
              //                   },
              //                   child: const Text('Cancel'),
              //                 ),
              //                 TextButton(
              //                   onPressed: () async {
              //                     bool deleteSuccess =
              //                         await deleteDocument(widget.document);
              //                     Navigator.of(context)
              //                         .pop(); // Close the dialog
              //                     if (deleteSuccess) {
              //                       Navigator.of(context).pushReplacement(
              //                         MaterialPageRoute(
              //                           builder: (context) => const HomePage(),
              //                         ),
              //                       );
              //                       ScaffoldMessenger.of(context)
              //                           .showSnackBar(const SnackBar(
              //                         content: Text(
              //                           'Document deleted successfully',
              //                           style: TextStyle(
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         backgroundColor: Colors.green,
              //                       ));
              //                     } else {
              //                       ScaffoldMessenger.of(context)
              //                           .showSnackBar(const SnackBar(
              //                         content: Text(
              //                           'Failed to delete document',
              //                           style: TextStyle(
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         backgroundColor: Colors.red,
              //                       ));
              //                     }
              //                   },
              //                   child: Container(
              //                     decoration: BoxDecoration(
              //                       color: Colors.red,
              //                       borderRadius: BorderRadius.circular(12),
              //                     ),
              //                     padding: const EdgeInsets.symmetric(
              //                         horizontal: 16, vertical: 8),
              //                     child: const Text(
              //                       'Delete',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             );
              //           },
              //         );
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.red,
              //       ),
              //       child: const Text("Delete",
              //           style: TextStyle(
              //             color: Colors.white,
              //           )),
              //     ),
              //   ],
              // ),
              const SpaceHeight(20),
            ],
          ),
        ),
      ),
    );
  }
}
