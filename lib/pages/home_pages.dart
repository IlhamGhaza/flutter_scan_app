import 'package:flutter/material.dart';
import 'package:flutter_scan_app/core/spaces.dart';
import 'package:flutter_scan_app/core/title_content.dart';
import 'package:flutter_scan_app/pages/latest_document_pages.dart';

import '../core/colors.dart';
import 'menu_categories.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Pages'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Scan kartu atau dokumenmu",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                const SpaceHeight(8),
                ElevatedButton(onPressed: () {}, child: const Text("Scan here"))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitleContent(title: "Category", onSeeAllTap: () {}),
          ),
          const SpaceHeight(12),
          const MenuCategories(),
          const SpaceHeight(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitleContent(title: "Latest Documents", onSeeAllTap: () {}),
          ),
          const SpaceHeight(12),
          const Expanded(
            child: LatestDocumentPages()
            ),
          const SpaceHeight(12),
        ],
      ),
    );
  }
}
