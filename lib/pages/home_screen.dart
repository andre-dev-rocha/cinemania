import 'package:flutter/material.dart';
import './drawer_screen.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinemania", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
        backgroundColor:Color.fromARGB(255, 7, 34, 59),
      ),
      drawer: DrawerScreen(),
      body: Center(
        child: Text("Olá mundo"),
      )
    );
  }
}