import 'package:flutter/material.dart';

import 'category_button.dart';
import 'document_category_page.dart';

class MenuCategories extends StatelessWidget {
  const MenuCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: CategoryButton(
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
        ),
        Flexible(
          child: CategoryButton(
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
        ),
        Flexible(
          child: CategoryButton(
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
        ),
      ],
    );
  }
}
