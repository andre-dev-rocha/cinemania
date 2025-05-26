import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/movie.dart';
import '../common/utils.dart';

class FirebaseService {
  static final _auth = FirebaseAuth.instance;
  static final _database = FirebaseDatabase.instance.ref();

  Future<List<Movie>> getFavoritos() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot =
        await _database.child('usuarios/${user.uid}/favoritos').get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    List<Movie> favoritos = [];

    data.forEach((key, value) {
      final movieMap = Map<String, dynamic>.from(value);
      favoritos.add(
        Movie(
          id: int.tryParse(key) ?? 0,
          title: movieMap['title'] ?? '',
          posterPath: movieMap['poster'] ?? '',
          overview: movieMap['overview'] ?? '',
          voteAverage:
              (movieMap['voteAverage'] != null)
                  ? double.tryParse(movieMap['voteAverage'].toString()) ?? 0.0
                  : 0.0,
          releaseDate: movieMap['releaseDate'] ?? '',
        ),
      );
    });

    return favoritos;
  }

  static String getImageUrl(String posterPath) {
    return '$baseImageMovie$posterPath';
  }

  /// ✅ Salvar filme como favorito ou assistido
  static Future<void> saveMovieData({
    required Movie movie,
    required String category, // 'favoritos' ou 'assistidos'
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _database.child('usuarios/${user.uid}/$category/${movie.id}');
    await ref.set({'title': movie.title, 'poster': movie.posterPath});
  }

  Future<void> removeFavorite(int movieId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _database.child('usuarios/${user.uid}/favoritos/$movieId').remove();
  }

  static Future<void> removeMovieData({
    required Movie movie,
    required String category,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref().child(
      'usuarios/${user.uid}/$category/${movie.id}',
    );
    await ref.remove();
  }

  /// ✅ Salvar avaliação
  static Future<void> saveRating({
    required String movieTitle,
    required double rating,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _database.child('usuarios/${user.uid}/avaliacoes/$movieTitle');
    await ref.set(rating);
  }

  /// ✅ Adicionar comentário
  static Future<void> addComment(String comment) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _database.child('usuarios/${user.uid}/comentarios');
    final snapshot = await ref.get();

    List<dynamic> comments = [];
    if (snapshot.exists) {
      comments = List<dynamic>.from(snapshot.value as List);
    }

    comments.add(comment);
    await ref.set(comments);
  }
}
