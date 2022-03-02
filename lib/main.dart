import 'package:flutter/material.dart';
import 'package:flutter_application_1/states/list.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.mitrTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.mitrTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      home: const ListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
