import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import '../common/utils.dart';

class CatalogService {
  
  Future<List<Map<String,dynamic>>> getFilmePorNome(String query)async{
    try{
      final response = await http.get(Uri.parse(baseUrl+"/search/movie?api_key=$apiKey"+"&query=${Uri.encodeComponent(query)}"+"&language=pt-BR"));

      if (response.statusCode == 200){
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["results"]);
      }
      return [];
    }catch(e){
      print("Erro ao buscar o filme: $e");
      return [];
    }
  }
}