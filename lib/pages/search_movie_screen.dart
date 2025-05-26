import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cinemania/model/movie.dart';
import 'package:cinemania/pages/movie_detail_screen.dart';
import '../common/utils.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({super.key});

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<dynamic>>? _searchResults;

  Future<List<dynamic>> fetchMovies(String query) async {
    final url = Uri.parse(
      "$baseUrl/search/movie?api_key=$apiKey&language=pt-BR&query=$query",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Falha ao carregar filmes');
    }
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = fetchMovies(query);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Filmes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Digite o título do filme...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _searchResults == null
                      ? const Center(
                        child: Text('Digite um título para buscar.'),
                      )
                      : FutureBuilder<List<dynamic>>(
                        future: _searchResults,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Erro: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Nenhum filme encontrado.'),
                            );
                          } else {
                            final movies = snapshot.data!;
                            return ListView.separated(
                              itemCount: movies.length,
                              separatorBuilder:
                                  (context, index) => const Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                              itemBuilder: (context, index) {
                                final movieData = movies[index];
                                final movie = Movie(
                                  id: movieData['id'],
                                  title: movieData['title'] ?? 'Sem título',
                                  overview:
                                      movieData['overview'] ?? 'Sem descrição',
                                  posterPath: movieData['poster_path'] ?? '',
                                  releaseDate:
                                      movieData['release_date'] ?? 'Sem data',
                                  voteAverage:
                                      (movieData['vote_average'] ?? 0)
                                          .toDouble(),
                                );

                                final imageUrl =
                                    movie.posterPath.isNotEmpty
                                        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                        : null;

                                return ListTile(
                                  leading:
                                      imageUrl != null
                                          ? Image.network(imageUrl, width: 50)
                                          : const Icon(Icons.movie),
                                  title: Text(movie.title),
                                  subtitle: Text(
                                    movie.overview,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                MovieDetailScreen(movie: movie),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
