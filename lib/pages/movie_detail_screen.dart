import 'package:flutter/material.dart';
import 'package:cinemania/model/movie.dart';
import '../services/firebase_service.dart';
import '../services/movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  
  double userRating = 5.0;
  bool isWatched = false;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addToFavorites() async {
    await FirebaseService.saveMovieData(
      movie: widget.movie,
      category: 'favoritos',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.movie.title} adicionado aos favoritos!')),
    );
  }

  void markAsWatched(bool value) async {
    setState(() => isWatched = value);
    if (isWatched) {
      await FirebaseService.saveMovieData(
        movie: widget.movie,
        category: 'assistidos',
      );
    } else {
    await FirebaseService.removeMovieData(
      movie: widget.movie,
      category: 'assistidos',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.movie.title} removido dos assistidos!')),
    );
  }
  }

  void sendRating() async {
    await FirebaseService.saveRating(
      movieTitle: widget.movie.title,
      rating: userRating,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nota enviada com sucesso!')),
    );
  }

  void sendComment() async {
    if (commentController.text.trim().isEmpty) return;

    await FirebaseService.addComment(commentController.text.trim());
    commentController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentário enviado!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: addToFavorites,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie.posterPath.isNotEmpty
                ? Image.network(
                    MovieService.getImageUrl(movie.posterPath),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.movie, size: 100),
            const SizedBox(height: 16),
            Text(movie.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Nota: ${movie.voteAverage.toStringAsFixed(1)}'),
            const SizedBox(height: 8),
            Text('Lançamento: ${movie.releaseDate}'),
            const SizedBox(height: 16),
            Text(movie.overview),
            const Divider(height: 32),

            /// ✅ Switch: Assistido
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Marcar como assistido'),
                Switch(
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.black,
                  value: isWatched,
                  onChanged: markAsWatched,
                ),
              ],
            ),
            const Divider(height: 32),

            /// ✅ Slider: Nota
            const Text('Sua nota'),
            Slider(
              value: userRating,
              min: 1,
              max: 10,
              divisions: 9,
              label: userRating.toString(),
              onChanged: (value) {
                setState(() => userRating = value);
              },
            ),
            ElevatedButton(
              onPressed: sendRating,
              child: const Text('Enviar nota'),
            ),
            const Divider(height: 32),

            /// ✅ Comentários
            const Text('Enviar comentário'),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Escreva seu comentário...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: sendComment,
              child: const Text('Enviar comentário'),
            ),
          ],
        ),
      ),
    );
  }
}
