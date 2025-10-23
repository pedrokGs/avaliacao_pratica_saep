import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema/core/riverpod/riverpod.dart';
import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/domain/usecases/create_produto_use_case.dart';
import 'package:sistema/features/products/domain/usecases/delete_produto_use_case.dart';
import 'package:sistema/features/products/domain/usecases/get_produtos_use_case.dart';
import 'package:sistema/features/products/domain/usecases/update_produto_use_case.dart';

class ProdutoState {
  final List<Produto> produtos;
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  ProdutoState({
    this.produtos = const [],
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  ProdutoState copyWith({
    List<Produto>? produtos,
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return ProdutoState(
      produtos: produtos ?? this.produtos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      success: success ?? this.success,
    );
  }
}

class ProdutoNotifier extends Notifier<ProdutoState> {
  late final GetProdutosUseCase getProdutosUseCase;
  late final CreateProdutoUseCase createProdutoUseCase;
  late final UpdateProdutoUseCase updateProdutoUseCase;
  late final DeleteProdutoUseCase deleteProdutoUseCase;

  @override
  ProdutoState build() {
    getProdutosUseCase = ref.watch(getProdutosUseCaseProvider);
    createProdutoUseCase = ref.watch(createProdutoUseCaseProvider);
    updateProdutoUseCase = ref.watch(updateProdutoUseCaseProvider);
    deleteProdutoUseCase = ref.watch(deleteProdutoUseCaseProvider);
    return ProdutoState();
  }

  Future<void> loadProdutos() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final produtos = await getProdutosUseCase.call();
      state = state.copyWith(produtos: produtos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> createProduto(Produto produto) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await createProdutoUseCase.call(produto);
      await loadProdutos();
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateProduto(Produto produto) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await updateProdutoUseCase.call(produto);
      await loadProdutos();
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteProduto(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await deleteProdutoUseCase.call(id);
      await loadProdutos();
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void resetSuccess() {
    state = state.copyWith(success: false);
  }
}

final produtoNotifierProvider = NotifierProvider<ProdutoNotifier, ProdutoState>(() => ProdutoNotifier());
