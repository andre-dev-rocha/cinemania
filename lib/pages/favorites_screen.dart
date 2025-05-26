import 'package:flutter/material.dart';
import 'package:cinemania/model/movie.dart';
import '../services/firebase_service.dart';
import 'movie_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Movie>> getFavoriteMovies() async {
    return await _firebaseService.getFavoritos();
  }

  Future<void> removeFavorite(int movieId) async {
    await _firebaseService.removeFavorite(movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Favoritos'),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<List<Movie>>(
        future: getFavoriteMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return const Center(child: Text('Nenhum favorito ainda.'));
          }
          return ListView.separated(
            itemCount: favorites.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(height: 1, thickness: 1, color: Colors.black),
            itemBuilder: (context, index) {
              final movie = favorites[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading:
                      movie.posterPath.isNotEmpty
                          ? Image.network(
                            FirebaseService.getImageUrl(movie.posterPath),
                            width: 50,
                          )
                          : const Icon(Icons.movie),
                  title: Text(movie.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await removeFavorite(movie.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} removido dos favoritos.', ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
