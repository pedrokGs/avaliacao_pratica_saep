import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/domain/repository/produto_repository.dart';

class UpdateProdutoUseCase {
  final ProdutoRepository repository;

  UpdateProdutoUseCase({required this.repository});

  Future<Produto> call(Produto produto) async {
    return await repository.updateProduct(produto);
  }
}
