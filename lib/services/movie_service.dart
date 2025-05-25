import 'dart:convert';
import '../model/movie.dart';
import 'package:http/http.dart' as http;
import '../common/utils.dart';

class MovieService {
  Future<List<Movie>> getFilmes({int pagina = 1}) async {
    String url =
        '$baseUrl/movie/popular?api_key=$apiKey&page=$pagina&language=pt-BR';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> resultados = data['results'];

        return resultados.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception("Falha ao carregar os filmes");
      }
    } catch (e) {
      throw Exception("Erro ao conectar: $e");
    }
  }

  static String getImageUrl(String posterPath){
    if(posterPath.isEmpty) return '';
    return "$baseImageMovie$posterPath";
  }
}
