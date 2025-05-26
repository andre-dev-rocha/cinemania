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
        scaffoldBackgroundColor: Color.fromARGB(255, 88, 135, 179),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.grey[300]
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 7, 34, 59),
          iconTheme: IconThemeData(
            color: Colors.white
          )
        )
      ),
      home: AuthCheck(),
      debugShowCheckedModeBanner: false,
    );
  }
}