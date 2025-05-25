import 'package:cinemania/pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinemania/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Future<Map<String, dynamic>?> dadosUsuario(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

    return snapshot.data();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Image.network(
                "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_640.png",
              ),
            ),
            accountName: Text("teste 123"),
            accountEmail: Text(
              Provider.of<AuthService>(context).usuario?.email as String,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    child: Text("Sair do App", style: TextStyle()),
                    onTap: () => context.read<AuthService>().logout(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
