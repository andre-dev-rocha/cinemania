import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../common/utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, dynamic>> usuarios = [];
  bool isLoading = true;

  final url =
      "$baseDatabaseUrl"
      "/usuarios.json";

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null) {
          List<Map<String, dynamic>> listaUsuarios = [];
          data.forEach((key, value) {
            listaUsuarios.add({
              'uid': key,
              'nome': value['nome'],
              'email': value['email'],
            });
          });

          setState(() {
            usuarios = listaUsuarios;
            isLoading = false;
          });
        } else {
          setState(() {
            usuarios = [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Erro ao carregar usuários: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro na requisição: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Usuários',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : usuarios.isEmpty
              ? const Center(child: Text('Nenhum usuário encontrado.'))
              : ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(usuario['nome'] ?? 'Sem nome'),
                    subtitle: Text(usuario['email'] ?? 'Sem email'),
                  );
                },
              ),
    );
  }
}
