import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import '../core/colors.dart';
import '../core/spaces.dart';
import '../data/datasource/document_local_datasource.dart';
import '../data/models/documenet_model.dart';
import 'edit_document_page.dart';
import 'home_page.dart';

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
  // int _currentImageIndex = 0;

  Future<bool> deleteDocument(DocumentModel document) async {
    try {
      int deletedRows =
          await DocumentLocalDatasource.instance.deleteDocument(document.id!);

      if (deletedRows > 0) {
        for (var imagePath in document.path!) {
          final file = File(imagePath);
          await file.delete();
        }
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
    for (var imagePath in widget.document.path!) {
      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to access folder. Please grant the necessary permissions.'),
        ),
      );
    }
  }

  Future<void> saveAsImage() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        for (var imagePath in widget.document.path!) {
          final file = File(path.join(selectedDirectory,
              '${path.basenameWithoutExtension(imagePath)}.png'));
          await File(imagePath).copy(file.path);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Images saved to $selectedDirectory'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Directory not selected, images not saved'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to access folder. Please grant the necessary permissions.'),
        ),
      );
    }
  }

  // Text extraction function using google_mlkit_text_recognition
  Future<void> _extractTextFromImage() async {
    if (widget.document.path == null || widget.document.path!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images to extract text from')),
      );
      return;
    }

    String extractedText = '';
    for (String imagePath in widget.document.path!) {
      final inputImage = InputImage.fromFilePath(imagePath);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      extractedText += recognizedText.text + '\n';
    }

    // Show the extracted text in a dialog or another screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Extracted Text'),
        content: SingleChildScrollView(
          child: Text(extractedText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Document'),
        actions: [
          IconButton(
            icon: Icon(Icons.font_download),
            onPressed: _extractTextFromImage,
            color: AppColors.primary,
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.primary,
            ),
            onPressed: () {
               Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EditDocumentPage(document: widget.document),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              // Add delete functionality here
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
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          bool deleteSuccess =
                              await deleteDocument(widget.document);
                          Navigator.of(context).pop();
                          if (deleteSuccess) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
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
          ),
        ],
        centerTitle: false,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.document.path!.map((path) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SpaceHeight(20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: saveAsPdf,
                        child: const Text("Save as PDF"),
                      ),
                      ElevatedButton(
                        onPressed: saveAsImage,
                        child: const Text("Save as Image"),
                      ),
                    ],
                  ),
                  const SpaceHeight(25),
                  // InkWell(
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: const Text('Confirm Delete'),
                  //           content: const Text(
                  //               'Are you sure you want to delete this document?'),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //               child: const Text('Cancel'),
                  //             ),
                  //             TextButton(
                  //               onPressed: () async {
                  //                 bool deleteSuccess =
                  //                     await deleteDocument(widget.document);
                  //                 Navigator.of(context).pop();
                  //                 if (deleteSuccess) {
                  //                   Navigator.of(context).pushReplacement(
                  //                     MaterialPageRoute(
                  //                       builder: (context) => const HomePage(),
                  //                     ),
                  //                   );
                  //                   ScaffoldMessenger.of(context)
                  //                       .showSnackBar(const SnackBar(
                  //                     content: Text(
                  //                       'Document deleted successfully',
                  //                       style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     backgroundColor: Colors.green,
                  //                   ));
                  //                 } else {
                  //                   ScaffoldMessenger.of(context)
                  //                       .showSnackBar(const SnackBar(
                  //                     content: Text(
                  //                       'Failed to delete document',
                  //                       style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     backgroundColor: Colors.red,
                  //                   ));
                  //                 }
                  //               },
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.red,
                  //                   borderRadius: BorderRadius.circular(12),
                  //                 ),
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 16, vertical: 8),
                  //                 child: const Text(
                  //                   'Delete',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.delete, color: Colors.red),
                  //         SizedBox(width: 8),
                  //         Text(
                  //           'Delete',
                  //           style: TextStyle(color: Colors.red),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SpaceHeight(20),
            ],
          ),
        ),
      ),
    );
  }
}
