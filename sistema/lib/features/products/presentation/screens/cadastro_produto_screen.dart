import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/presentation/state/produto_state.dart';
import 'package:sistema/features/products/presentation/widgets/produto_form.dart';

class CadastroProdutoScreen extends ConsumerStatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  ConsumerState<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends ConsumerState<CadastroProdutoScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final produtoState = ref.watch(produtoNotifierProvider);
    final produtoNotifier = ref.read(produtoNotifierProvider.notifier);
    final filteredProdutos = produtoState.produtos.where((produto) {
      final query = searchController.text.toLowerCase();
      return produto.name.toLowerCase().contains(query) ||
             produto.model.toLowerCase().contains(query) ||
             produto.material.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProdutoForm(
              onSubmit: (produto) async {
                await produtoNotifier.createProduto(produto);
                if (produtoState.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produto criado com sucesso!'),
                    ),
                  );
                  produtoNotifier.resetSuccess();
                } else if (produtoState.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: ${produtoState.errorMessage}'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar produtos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: produtoState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : produtoState.errorMessage != null
                  ? Center(child: Text('Erro: ${produtoState.errorMessage}'))
                  : ListView.builder(
                      itemCount: filteredProdutos.length,
                      itemBuilder: (context, index) {
                        final produto = filteredProdutos[index];
                        return Card(
                          child: ListTile(
                            title: Text(produto.name),
                            subtitle: Text('Modelo: ${produto.model}'),
                            tileColor: produto.minStock > produto.currentStock
                                ? Color.fromARGB(255, 255, 78, 78)
                                : Color.fromARGB(255, 230, 230, 230),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, ref, produto);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await produtoNotifier.deleteProduto(
                                      produto.id,
                                    );
                                    if (produtoState.success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Produto deletado com sucesso!',
                                          ),
                                        ),
                                      );
                                      produtoNotifier.resetSuccess();
                                    } else if (produtoState.errorMessage !=
                                        null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Erro: ${produtoState.errorMessage}',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Produto produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Produto'),
        content: ProdutoForm(
          initialProduto: produto,
          onSubmit: (updatedProduto) async {
            final produtoNotifier = ref.read(produtoNotifierProvider.notifier);
            await produtoNotifier.updateProduto(updatedProduto);
            final state = ref.read(produtoNotifierProvider);
            if (state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produto atualizado com sucesso!'),
                ),
              );
              produtoNotifier.resetSuccess();
              Navigator.pop(context);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: ${state.errorMessage}')),
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
