import 'package:sistema/features/products/domain/entity/produto.dart';

abstract class ProdutoRepository {
  Future<Produto> createProduct(Produto produto);
  Future<Produto> getProductById(String id);
  Future<List<Produto>> getProducts();
  Future<Produto> updateProduct(Produto produto);
  Future<void> deleteProduct(String id);
}
