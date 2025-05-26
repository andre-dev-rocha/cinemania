import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  Future<List<Map<String, dynamic>>> getRatings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final ref = FirebaseDatabase.instance.ref().child('usuarios/${user.uid}/avaliacoes');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((entry) {
        return {
          'movieTitle': entry.key,   // ← Agora usa o título como chave
          'rating': entry.value,
        };
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Avaliações')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getRatings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final ratings = snapshot.data!;
          if (ratings.isEmpty) return const Center(child: Text('Nenhuma avaliação enviada.'));
          return ListView.builder(
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              final rating = ratings[index];
              return ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text('Filme: ${rating['movieTitle']}'),  // ← Agora exibe o título
                subtitle: Text('Nota: ${rating['rating']}'),
              );
            },
          );
        },
      ),
    );
  }
}
