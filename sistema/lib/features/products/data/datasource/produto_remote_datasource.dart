import 'package:sistema/features/products/data/model/produto_model.dart';

abstract class ProductRemoteDatasource {
  Future<ProdutoModel> createProduct(ProdutoModel produtoModel);
  Future<ProdutoModel> getProductById(String id);
  Future<List<ProdutoModel>> getProduts();
  Future<ProdutoModel> updateProduct(ProdutoModel produtoModel);
  Future<void> deleteProduct(String id);
}