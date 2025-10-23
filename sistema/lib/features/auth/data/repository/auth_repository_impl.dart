import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:sistema/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource authRemoteDataSource;
  
  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  User? get getCurrentUser => authRemoteDataSource.getCurrentUser ?? null;

  @override
  Future<User?> signIn({required String email, required String password}) async{
    return await authRemoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return await authRemoteDataSource.signOut();
  }

  @override
  Future<User?> signUp({required String email, required String password}) async {
    return await authRemoteDataSource.signUp(email: email, password: password);
  }
  
}