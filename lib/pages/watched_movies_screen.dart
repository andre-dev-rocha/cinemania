import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/movie.dart';
import '../services/firebase_service.dart';
import 'movie_detail_screen.dart';
import '../services/movie_service.dart';
import '../common/utils.dart';
class WatchedMoviesScreen extends StatefulWidget {
  const WatchedMoviesScreen({super.key});

  @override
  State<WatchedMoviesScreen> createState() => _WatchedMoviesScreenState();
}

class _WatchedMoviesScreenState extends State<WatchedMoviesScreen> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  Future<List<Movie>> getWatchedMovies() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final ref = _database.child('usuarios/${user.uid}/assistidos');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((entry) {
        final movieData = Map<String, dynamic>.from(entry.value);
        return Movie(
          id: int.tryParse(entry.key) ?? 0,
          title: movieData['title'] ?? '',
          posterPath: movieData['poster'] ?? '',
          overview: movieData['overview'] ?? '',
          voteAverage: double.tryParse(movieData['voteAverage'].toString()) ?? 0.0,
          releaseDate: movieData['releaseDate'] ?? '',
        );
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filmes Assistidos')),
      body: FutureBuilder<List<Movie>>(
        future: getWatchedMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text('Nenhum filme assistido.'));
          }
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: movie.posterPath.isNotEmpty
                    ? Image.network(
                        "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                        width: 50,
                      )
                    : const Icon(Icons.movie),
                title: Text(movie.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
