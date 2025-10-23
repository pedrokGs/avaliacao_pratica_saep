import 'package:sistema/features/products/data/datasource/produto_remote_datasource.dart' as datasource;
import 'package:sistema/features/products/data/model/produto_model.dart';
import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/domain/repository/produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final datasource.ProductRemoteDatasource remoteDatasource;

  ProdutoRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Produto> createProduct(Produto produto) async {
    final model = ProdutoModel(
      model: produto.model,
      name: produto.name,
      material: produto.material,
      weight: produto.weight,
      size: produto.size,
      tension: produto.tension,
      currentStock: produto.currentStock,
      minStock: produto.minStock,
    );
    final result = await remoteDatasource.createProduct(model);
    return result.toEntity();
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDatasource.deleteProduct(id);
  }

  @override
  Future<Produto> getProductById(String id) async {
    final result = await remoteDatasource.getProductById(id);
    return result.toEntity();
  }

  @override
  Future<List<Produto>> getProducts() async {
    final result = await remoteDatasource.getProduts();
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Produto> updateProduct(Produto produto) async {
    final model = ProdutoModel(
      id: produto.id,
      model: produto.model,
      name: produto.name,
      material: produto.material,
      weight: produto.weight,
      size: produto.size,
      tension: produto.tension,
      currentStock: produto.currentStock,
      minStock: produto.minStock,
    );
    final result = await remoteDatasource.updateProduct(model);
    return result.toEntity();
  }
}
