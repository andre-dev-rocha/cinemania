import 'package:flutter/material.dart';
import 'package:cinemania/model/movie.dart';
import 'package:cinemania/pages/movie_detail_screen.dart';
import '../services/firebase_service.dart';
import '../services/movie_service.dart';

class RecommendedMoviesScreen extends StatefulWidget {
  const RecommendedMoviesScreen({super.key});

  @override
  State<RecommendedMoviesScreen> createState() =>
      _RecommendedMoviesScreenState();
}

class _RecommendedMoviesScreenState extends State<RecommendedMoviesScreen> {
  List<Movie> recommendedMovies = [];

  @override
  void initState() {
    super.initState();
    loadRecommendedMovies();
  }

  Future<void> loadRecommendedMovies() async {
    final movies = await FirebaseService.getRecommendedMovies();
    setState(() {
      recommendedMovies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Recomendados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          recommendedMovies.isEmpty
              ? const Center(child: Text('Nenhum filme recomendado ainda.'))
              : ListView.separated(
                itemCount: recommendedMovies.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final movie = recommendedMovies[index];
                  return ListTile(
                    leading:
                        movie.posterPath.isNotEmpty
                            ? Image.network(
                              MovieService.getImageUrl(movie.posterPath),
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
              ),
    );
  }
}
