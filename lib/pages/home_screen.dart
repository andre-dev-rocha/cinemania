import 'package:cinemania/model/movie.dart';
import 'package:flutter/material.dart';
import './drawer_screen.dart';
import '../services/movie_service.dart';
import './movie_detail_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _movieService = MovieService();
  final ScrollController _scrollController = ScrollController();

  final List<Movie> _filmes = [];
  int _paginaAtual = 1;
  bool _carregando = false;
  bool _temMais = true;

  @override
  void initState() {
    super.initState();
    _carregarFilmes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_carregando &&
          _temMais) {
        _carregarFilmes();
      }
    });
  }

  Future<void> _carregarFilmes() async {
    setState(() {
      _carregando = true;
    });

    try {
      final novosFilmes = await _movieService.getFilmes(pagina: _paginaAtual);

      setState(() {
        if (novosFilmes.isEmpty) {
          _temMais = false;
        } else {
          _paginaAtual++;
          _filmes.addAll(novosFilmes);
        }
      });
    } catch (e) {
      print("Erro ao carregar filmes: $e");
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lançamentos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 7, 34, 59),
      ),
      drawer: DrawerScreen(),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _filmes.length + (_carregando ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= _filmes.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final filme = _filmes[index];

          return GridTile(
            child: Card(
              elevation: 8,
              shadowColor: const Color(0x4D673AB7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: filme,),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          color: Colors.grey[300],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child:
                              filme.posterPath.isNotEmpty
                                  ? Image.network(
                                    MovieService.getImageUrl(filme.posterPath),
                                    fit: BoxFit.cover,
                                  )
                                  : Image.network(
                                    "https://imgs.search.brave.com/d1yJc4j4c5H64nGTWGsMLiLIoAjlYoFHJuUCes2QkkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWdz/LnNlYXJjaC5icmF2/ZS5jb20vNHpLb2hH/VXctbjBIMERDQi1W/S2RSQ0duel96dTN0/VUlXMDRjMnNsUDhx/cy9yczpmaXQ6NTAw/OjA6MDowL2c6Y2Uv/YUhSMGNITTZMeTlw/YldjdS9abkpsWlhC/cGF5NWpiMjB2L1pu/SmxaUzEyWldOMGIz/SXYvY0dGblpTMW1i/M1Z1WkMxbi9iR2ww/WTJndFltRmphMmR5/L2IzVnVaRjh5TXkw/eU1UUTQvTURjM01U/QTFMbXB3Wno5ei9a/VzEwUFdGcGMxOW9l/V0p5L2FXUW1kejAz/TkRB",
                                  ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filme.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  filme.voteAverage.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
