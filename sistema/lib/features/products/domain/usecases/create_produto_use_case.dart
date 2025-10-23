import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/domain/repository/produto_repository.dart';

class CreateProdutoUseCase {
  final ProdutoRepository repository;

  CreateProdutoUseCase({required this.repository});

  Future<Produto> call(Produto produto) async {
    return await repository.createProduct(produto);
  }
}
