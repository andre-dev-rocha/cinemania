import 'package:cinemania/pages/menu_screen.dart';
import './main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuBackgroundColor: Colors.pink,
      slideWidth: MediaQuery.of(context).size.width*0.8,
      controller: ZoomDrawerController(),
      menuScreen: MenuScreen(),
      mainScreen: MainScreen(),
      clipMainScreen: false,
    );
  }
}
