import 'package:sistema/features/products/domain/repository/produto_repository.dart';

class DeleteProdutoUseCase {
  final ProdutoRepository repository;

  DeleteProdutoUseCase({required this.repository});

  Future<void> call(String id) async {
    return await repository.deleteProduct(id);
  }
}
