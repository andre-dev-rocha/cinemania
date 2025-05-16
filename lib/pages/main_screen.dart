import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinemania", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
        backgroundColor:Color.fromARGB(255, 7, 34, 59),
        leading: IconButton(onPressed: (){
          if(ZoomDrawer.of(context)!.isOpen()){
            ZoomDrawer.of(context)!.close();
          } else{
            ZoomDrawer.of(context)!.open();
          }
        }, icon: Icon(Icons.menu, color: Colors.white,)
      ),
      actions: [
        IconButton(icon:Icon(Icons.search),color: Colors.white, onPressed: () {},),

      ],
    )
    );
  }
}