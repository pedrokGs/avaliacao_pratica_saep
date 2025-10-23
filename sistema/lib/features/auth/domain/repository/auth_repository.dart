import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository{
    User? get getCurrentUser;
    Future<User?> signIn({required String email, required String password});
    Future<User?> signUp({required String email, required String password});
    Future<void> signOut();
}