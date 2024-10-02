import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //lock potrait mode only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.white,
          titleTextStyle: GoogleFonts.quicksand(
            color: AppColors.primary,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.black,
          ),
          centerTitle: true,
          shape: Border(
            bottom: BorderSide(
              color: AppColors.black.withOpacity(0.05),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}