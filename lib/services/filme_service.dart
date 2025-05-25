import 'dart:convert';
import '../model/filme.dart';
import 'package:http/http.dart' as http;

class FilmeService {
  final String baseURL = "https://api.themoviedb.org/3";
  final chaveAPI = "df23d7f72a3dce5a4d496283b8133f48";

  Future<List<Filme>> getFilmes() async {
    String url = '$baseURL/tarefas';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> listaTarefas = jsonDecode(response.body);
      return listaTarefas.map((tarefa) => Filme.fromJson(tarefa)).toList();
    } else {
      throw Exception('Erro ao recuperar as tarefas');
    }
  }
}