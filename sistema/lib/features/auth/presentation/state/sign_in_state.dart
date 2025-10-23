import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema/core/riverpod/riverpod.dart';
import 'package:sistema/features/auth/domain/usecases/sign_in_use_case.dart';

class SignInState{
  final String? errorMessage;
  final bool isLoading;
  final bool success;

  SignInState({this.errorMessage, this.isLoading = false, this.success = false});
}

class SignInStateNotifier extends Notifier<SignInState>{
  late final SignInUseCase signInUseCase;

  @override
  SignInState build() {
    signInUseCase = ref.watch(signInUseCaseProvider);
    return SignInState();
  }

  Future<void> signIn(String email, String password) async {
    state = SignInState(isLoading: true);
    try{
      await signInUseCase.call(email: email, password: password);
      state = SignInState(isLoading: false, success: true);
    } on FirebaseAuthException {
      state = SignInState(isLoading: false, errorMessage: "Credenciais inválidas, verifique a senha e o email");
    } catch(e){
      state = SignInState(isLoading: false, errorMessage: "Erro desconhecido: $e");
    }
  }
}

final signInNotifierProvider = NotifierProvider<SignInStateNotifier, SignInState>(() => SignInStateNotifier(),);