import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema/features/auth/data/datasource/auth_remote_data_source.dart';

class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceFirebase({required this.firebaseAuth});

  @override
  User? get getCurrentUser => firebaseAuth.currentUser;
  
  @override
  Future<User?> signIn({required String email, required String password}) async {
    try{
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(_){
      rethrow;
    } catch(e){
      rethrow;
    }
  }
  
  @override
  Future<void> signOut()async{
    try{
      return await firebaseAuth.signOut();
    } on FirebaseAuthException catch(_){
      rethrow;
    } catch(e){
      rethrow;
    }
  }
  
  @override
  Future<User?> signUp({required String email, required String password})async {
    try{
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(_){
      rethrow;
    } catch(e){
      rethrow;
    }
  }


}