import 'package:cinemania/pages/drawer_screen.dart';
import 'package:flutter/material.dart';
import './pages/main_screen.dart';
main()=>runApp(MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}