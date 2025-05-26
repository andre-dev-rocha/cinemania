import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  Future<List<String>> getComments() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final ref = _database.child('usuarios/${user.uid}/comentarios');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
      final data = List<dynamic>.from(snapshot.value as List);
      return data.map((e) => e.toString()).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Comentários', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<String>>(
        future: getComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final comments = snapshot.data ?? [];
          if (comments.isEmpty) {
            return const Center(child: Text('Nenhum comentário enviado.'));
          }
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.comment),
                title: Text(comments[index]),
              );
            },
          );
        },
      ),
    );
  }
}
