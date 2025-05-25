import 'package:cinemania/services/auth_service.dart';
import 'package:cinemania/widgets/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> AuthService())
      ],
      child: MeuApp())
    );
  }

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
      ),
      home: AuthCheck(),
      debugShowCheckedModeBanner: false,
    );
  }
}