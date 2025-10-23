import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema/features/auth/domain/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<User?> call({required String email, required String password}) async {
    return await authRepository.signIn(email: email, password: password);
  }
}