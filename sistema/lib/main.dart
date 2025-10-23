import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:sistema/features/products/presentation/screens/home_screen.dart';
import 'package:sistema/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/signIn",
      routes: {
        "/signIn": (context) => SignInScreen(),
        "/": (context) => HomeScreen(),
      },
    );
  }
}
