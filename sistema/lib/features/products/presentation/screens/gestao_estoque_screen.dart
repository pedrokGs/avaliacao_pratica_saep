import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema/features/products/domain/entity/produto.dart';
import 'package:sistema/features/products/presentation/state/produto_state.dart';

class GestaoEstoqueScreen extends ConsumerStatefulWidget {
  const GestaoEstoqueScreen({super.key});

  @override
  ConsumerState<GestaoEstoqueScreen> createState() => _GestaoEstoqueScreenState();
}

class _GestaoEstoqueScreenState extends ConsumerState<GestaoEstoqueScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final produtoState = ref.watch(produtoNotifierProvider);
    final produtoNotifier = ref.read(produtoNotifierProvider.notifier);

    final sortedProdutos = [...produtoState.produtos]
      ..sort((a, b) => a.name.compareTo(b.name));

    final filteredProdutos = sortedProdutos.where((produto) {
      final query = searchController.text.toLowerCase();
      return produto.name.toLowerCase().contains(query) ||
             produto.model.toLowerCase().contains(query) ||
             produto.material.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Estoque'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                            subtitle: Text(
                              'Estoque Atual: ${produto.currentStock} | Mínimo: ${produto.minStock}',
                            ),
                            tileColor: produto.minStock > produto.currentStock
                                ? Color.fromARGB(255, 255, 78, 78)
                                : Color.fromARGB(255, 230, 230, 230),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showMovimentacaoDialog(
                                    context,
                                    ref,
                                    produto,
                                    'entrada',
                                  ),
                                  child: const Text('Entrada'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _showMovimentacaoDialog(
                                    context,
                                    ref,
                                    produto,
                                    'saida',
                                  ),
                                  child: const Text('Saída'),
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

  void _showMovimentacaoDialog(
    BuildContext context,
    WidgetRef ref,
    Produto produto,
    String tipo,
  ) {
    final quantidadeController = TextEditingController();
    final dataController = TextEditingController(
      text: DateTime.now().toString().split(' ')[0],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Movimentação de ${tipo == 'entrada' ? 'Entrada' : 'Saída'}',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: dataController,
              decoration: const InputDecoration(labelText: 'Data (YYYY-MM-DD)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantidade =
                  double.tryParse(quantidadeController.text.trim()) ?? 0.0;
              if (quantidade > 0) {
                double newStock = produto.currentStock;
                if (tipo == 'entrada') {
                  newStock += quantidade;
                } else {
                  newStock -= quantidade;
                  if (newStock < produto.minStock) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alerta: Estoque abaixo do mínimo!'),
                      ),
                    );
                  }
                }

                final updatedProduto = produto.copyWith(currentStock: newStock);
                final produtoNotifier = ref.read(
                  produtoNotifierProvider.notifier,
                );
                await produtoNotifier.updateProduto(updatedProduto);

                final state = ref.read(produtoNotifierProvider);
                if (state.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Movimentação realizada com sucesso!'),
                    ),
                  );
                  produtoNotifier.resetSuccess();
                  Navigator.pop(context);
                } else if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: ${state.errorMessage}')),
                  );
                }
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
