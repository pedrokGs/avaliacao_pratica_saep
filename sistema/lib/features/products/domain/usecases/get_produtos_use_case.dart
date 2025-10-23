import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/domain/repository/produto_repository.dart';

class GetProdutosUseCase {
  final ProdutoRepository repository;

  GetProdutosUseCase({required this.repository});

  Future<List<Produto>> call() async {
    return await repository.getProducts();
  }
}
