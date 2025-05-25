import 'package:cinemania/pages/users_screen.dart';
import 'package:cinemania/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinemania/services/users_service.dart';
class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final UsersService _usersService = UsersService();
  
  
  String nome = "";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersScreen()),
                  ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.people, color: Colors.green, size: 30),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Usuarios",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GestureDetector(
              onTap: () => context.read<AuthService>().logout(),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.logout, color: Colors.red, size: 30),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Sair do App",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
