import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  Future<User?> call({required String email, required String password}) async {
    return await authRepository.signUp(email: email, password: password);
  }
}