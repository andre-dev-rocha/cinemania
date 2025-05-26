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
  bool isRecommended = false;
  final TextEditingController commentController = TextEditingController();
  List<String> publicComments = [];

  @override
  void initState() {
    super.initState();
    checkIfWatched();
    loadPublicComments();
    checkIfRecommended();
  }

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
      SnackBar(
        content: Text('${widget.movie.title} adicionado aos favoritos!'),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
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
        SnackBar(
          content: Text('${widget.movie.title} removido dos assistidos!'),
          backgroundColor: const Color(0xFF8B5CF6),
        ),
      );
    }
  }

  void sendRating() async {
    await FirebaseService.saveRating(
      movieTitle: widget.movie.title,
      rating: userRating,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nota enviada com sucesso!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void sendComment() async {
    if (commentController.text.trim().isEmpty) return;

    final comment = commentController.text.trim();

    await FirebaseService.addComment(comment);
    await FirebaseService.addPublicComment(
      movieId: widget.movie.id.toString(),
      comment: comment,
    );

    commentController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comentário enviado!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );

    await loadPublicComments();
  }

  Future<void> checkIfWatched() async {
    final isAlreadyWatched = await FirebaseService.isMovieInCategory(
      movie: widget.movie,
      category: 'assistidos',
    );
    setState(() {
      isWatched = isAlreadyWatched;
    });
  }

  Future<void> checkIfRecommended() async {
    final recommended = await FirebaseService.isMovieInCategory(
      movie: widget.movie,
      category: 'recomendados',
    );
    setState(() {
      isRecommended = recommended;
    });
  }

  void toggleRecommendation(bool value) async {
    setState(() {
      isRecommended = value;
    });

    if (value) {
      await FirebaseService.saveMovieData(
        movie: widget.movie,
        category: 'recomendados',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filme recomendado!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      await FirebaseService.removeMovieData(
        movie: widget.movie,
        category: 'recomendados',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filme removido das recomendações!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> loadPublicComments() async {
    final comments = await FirebaseService.getPublicComments(
      movieId: widget.movie.id.toString(),
    );
    setState(() {
      publicComments = comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fundo escuro azul
      appBar: AppBar(
        backgroundColor: const Color(0xFF475569), // AppBar azul escuro
        elevation: 0,
        title: Text(
          movie.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Color(0xFFE11D48)),
            onPressed: addToFavorites,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    movie.posterPath.isNotEmpty
                        ? Image.network(
                          MovieService.getImageUrl(movie.posterPath),
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          height: 300,
                          width: double.infinity,
                          color: const Color(0xFF374151),
                          child: const Icon(
                            Icons.movie,
                            size: 100,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB308),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Lançamento: ${movie.releaseDate}',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              movie.overview,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: const Color(0xFF334155)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Marcar como assistido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    activeColor: const Color(0xFF10B981),
                    inactiveTrackColor: const Color(0xFF475569),
                    inactiveThumbColor: const Color(0xFF94A3B8),
                    value: isWatched,
                    onChanged: markAsWatched,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recomendar este filme',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Checkbox(
                    activeColor: const Color(0xFF8B5CF6),
                    checkColor: Colors.white,
                    value: isRecommended,
                    onChanged: (value) => toggleRecommendation(value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sua avaliação',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFEAB308)),
                      const SizedBox(width: 8),
                      Text(
                        userRating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFEAB308),
                      inactiveTrackColor: const Color(0xFF475569),
                      thumbColor: const Color(0xFFEAB308),
                      overlayColor: const Color(0xFFEAB308).withOpacity(0.2),
                      valueIndicatorColor: const Color(0xFFEAB308),
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      value: userRating,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: userRating.toString(),
                      onChanged: (value) {
                        setState(() => userRating = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: sendRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEAB308),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Enviar avaliação',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deixe seu comentário',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escreva seu comentário...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF475569)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF475569)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: sendComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Enviar comentário',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comentários da comunidade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  publicComments.isEmpty
                      ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: Color(0xFF94A3B8),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Seja o primeiro a comentar!',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            publicComments
                                .map(
                                  (comment) => Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF475569),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Color(0xFF8B5CF6),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            comment,
                                            style: const TextStyle(
                                              color: Color(0xFFE2E8F0),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
