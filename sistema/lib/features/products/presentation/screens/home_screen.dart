import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema/core/riverpod/riverpod.dart';
import 'package:sistema/features/products/presentation/screens/cadastro_produto_screen.dart';
import 'package:sistema/features/products/presentation/screens/gestao_estoque_screen.dart';
import 'package:sistema/features/products/presentation/state/produto_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);
    final produtoState = ref.watch(produtoNotifierProvider);
    final produtoNotifier = ref.read(produtoNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (produtoState.produtos.isEmpty && !produtoState.isLoading) {
        produtoNotifier.loadProdutos();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Gestão'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(signOutUseCaseProvider).call();
              Navigator.pushReplacementNamed(context, '/signIn');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${user?.email ?? 'Usuário'}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastroProdutoScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Cadastro de Produto'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GestaoEstoqueScreen()),
                    );
                  },
                  icon: const Icon(Icons.inventory),
                  label: const Text('Gestão de Estoque'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (produtoState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (produtoState.errorMessage != null)
              Center(child: Text('Erro: ${produtoState.errorMessage}'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: produtoState.produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtoState.produtos[index];
                    return Card(
                      child: ListTile(
                        title: Text(produto.name),
                        subtitle: Text('Modelo: ${produto.model} | Estoque: ${produto.currentStock} ${produto.currentStock < produto.minStock ? "ABAIXO DO ESTOQUE MÍNIMO!" : ""}'),
                        tileColor: produto.minStock > produto.currentStock ? Color.fromARGB(255, 255, 78, 78) : Color.fromARGB(255, 230, 230, 230)
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
}
