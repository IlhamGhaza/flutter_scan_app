import 'package:flutter/material.dart';

import 'category_button.dart';
import 'document_category_page.dart';

class MenuCategories extends StatelessWidget {
  const MenuCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CategoryButton(
              imagePath: null,
              label: 'Catatan',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DocumentCategoryPage(
                            categoryTitle: 'Catatan')));
              },
            ),
            const SizedBox(width: 16),
            CategoryButton(
              imagePath: null,
              label: 'Kartu',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DocumentCategoryPage(categoryTitle: 'Kartu')));
              },
            ),
            const SizedBox(width: 16),
            CategoryButton(
              imagePath: null,
              label: 'Nota',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DocumentCategoryPage(categoryTitle: 'Nota')));
              },
            ),
            const SizedBox(width: 16),
            CategoryButton(
              imagePath: null,
              label: 'Surat',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DocumentCategoryPage(categoryTitle: 'Surat')));
              },
            ),
            ///you can add more here
            ///example
            
            // const SizedBox(width: 16),
            // CategoryButton(
            //   imagePath: null,
            //   label: '[here]',
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const DocumentCategoryPage(
            //                 categoryTitle: '[here]')));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
