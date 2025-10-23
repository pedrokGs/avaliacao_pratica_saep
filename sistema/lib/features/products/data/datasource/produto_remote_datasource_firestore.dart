import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema/features/products/data/datasource/produto_remote_datasource.dart';
import 'package:sistema/features/products/data/model/produto_model.dart';

class ProdutoRemoteDatasourceFirestore implements ProductRemoteDatasource {
  final FirebaseFirestore firestore;

  ProdutoRemoteDatasourceFirestore({required this.firestore});

  @override
  Future<ProdutoModel> createProduct(ProdutoModel produtoModel) async {
    final docRef = await firestore.collection('produtos').add(produtoModel.toJson());
    final doc = await docRef.get();
    return ProdutoModel.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await firestore.collection('produtos').doc(id).delete();
  }

  @override
  Future<ProdutoModel> getProductById(String id) async {
    final doc = await firestore.collection('produtos').doc(id).get();
    return ProdutoModel.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<List<ProdutoModel>> getProduts() async {
    final querySnapshot = await firestore.collection('produtos').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ProdutoModel.fromJson(data);
    }).toList();
  }

  @override
  Future<ProdutoModel> updateProduct(ProdutoModel produtoModel) async {
    await firestore.collection('produtos').doc(produtoModel.id).update(produtoModel.toJson());
    return produtoModel;
  }
}
