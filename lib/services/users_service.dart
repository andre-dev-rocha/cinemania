import 'package:flutter/material.dart';
import '../common/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class UsersService {

  Future<Map<String, dynamic>> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuário não logado');
    }

    final uid = user.uid;

    final response = await http.get(Uri.parse('$baseDatabaseUrl/$uid.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        return {
          'nome': data['nome'] ?? '',
          'email': data['email'] ?? '',
        };
      } else {
        throw Exception('Dados do usuário não encontrados');
      }
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }
}
