import 'package:flutter/material.dart';

class LatestDocumentPages extends StatefulWidget {
  const LatestDocumentPages({super.key});

  @override
  State<LatestDocumentPages> createState() => _LatestDocumentPagesState();
}

class _LatestDocumentPagesState extends State<LatestDocumentPages> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 3/2),
     itemBuilder: (context, index) => Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
          color: Colors.white,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.description,
            size: 72,
            color: Colors.grey,
          ),
          Text("Document ${index + 1}",
          style: const TextStyle(),
          textAlign: TextAlign.center,

          ),
        ]
      ),
     ),
    );
  }
}