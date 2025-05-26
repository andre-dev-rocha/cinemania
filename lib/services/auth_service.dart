import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;

  AuthException({required this.message});
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  User? usuario;

  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    }
    );
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  Future<void> registrar(String email, String senha, String nome) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      User? user = result.user;

      if (user != null) {
        await _salvarUsuario(user.uid, nome, email);
        _getUser();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException(message: "A senha é muito fraca!");
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(message: "Este email já está cadastrado");
      }
    }
  }

  Future<void> _salvarUsuario(String uid, String nome, String email) async {
    await _dbRef.child("usuarios").child(uid).set({
      'id': uid,
      'nome': nome,
      'email': email,
      "favoritos":[],
      "notas":{},
      "comentarios":{},
      "assistidos":[]
    }
    );
  }

  Future<void> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(message: "Usuário não encontrado!");
      } else if (e.code == 'wrong-password') {
        throw AuthException(message: "Senha incorreta!");
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _getUser();
  }
}
