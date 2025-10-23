import 'package:sistema/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase({required this.authRepository});

  Future<void> call() async {
    return await authRepository.signOut();
  }
}