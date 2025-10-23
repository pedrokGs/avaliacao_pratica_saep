import 'package:flutter/material.dart';
import 'package:sistema/features/products/domain/entity/produto.dart';

class ProdutoForm extends StatefulWidget {
  final Produto? initialProduto;
  final Function(Produto) onSubmit;

  const ProdutoForm({super.key, this.initialProduto, required this.onSubmit});

  @override
  _ProdutoFormState createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<ProdutoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _modelController;
  late TextEditingController _nameController;
  late TextEditingController _materialController;
  late TextEditingController _weightController;
  late TextEditingController _sizeController;
  late TextEditingController _tensionController;
  late TextEditingController _currentStockController;
  late TextEditingController _minStockController;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.initialProduto?.model ?? '');
    _nameController = TextEditingController(text: widget.initialProduto?.name ?? '');
    _materialController = TextEditingController(text: widget.initialProduto?.material ?? '');
    _weightController = TextEditingController(text: widget.initialProduto?.weight.toString() ?? '');
    _sizeController = TextEditingController(text: widget.initialProduto?.size.toString() ?? '');
    _tensionController = TextEditingController(text: widget.initialProduto?.tension.toString() ?? '');
    _currentStockController = TextEditingController(text: widget.initialProduto?.currentStock.toString() ?? '');
    _minStockController = TextEditingController(text: widget.initialProduto?.minStock.toString() ?? '');
  }

  @override
  void dispose() {
    _modelController.dispose();
    _nameController.dispose();
    _materialController.dispose();
    _weightController.dispose();
    _sizeController.dispose();
    _tensionController.dispose();
    _currentStockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final produto = Produto(
        id: widget.initialProduto?.id ?? '',
        model: _modelController.text.trim(),
        name: _nameController.text.trim(),
        material: _materialController.text.trim(),
        weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
        size: double.tryParse(_sizeController.text.trim()) ?? 0.0,
        tension: double.tryParse(_tensionController.text.trim()) ?? 0.0,
        currentStock: double.tryParse(_currentStockController.text.trim()) ?? 0.0,
        minStock: double.tryParse(_minStockController.text.trim()) ?? 0.0,
      );
      widget.onSubmit(produto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _modelController,
            decoration: const InputDecoration(labelText: 'Modelo'),
            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
          ),
          TextFormField(
            controller: _materialController,
            decoration: const InputDecoration(labelText: 'Material'),
            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
          ),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: 'Peso'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Campo obrigatório';
              if (double.tryParse(value) == null) return 'Valor inválido';
              return null;
            },
          ),
          TextFormField(
            controller: _sizeController,
            decoration: const InputDecoration(labelText: 'Tamanho'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Campo obrigatório';
              if (double.tryParse(value) == null) return 'Valor inválido';
              return null;
            },
          ),
          TextFormField(
            controller: _tensionController,
            decoration: const InputDecoration(labelText: 'Tensão'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Campo obrigatório';
              if (double.tryParse(value) == null) return 'Valor inválido';
              return null;
            },
          ),
          TextFormField(
            controller: _currentStockController,
            decoration: const InputDecoration(labelText: 'Estoque Atual'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Campo obrigatório';
              if (double.tryParse(value) == null) return 'Valor inválido';
              return null;
            },
          ),
          TextFormField(
            controller: _minStockController,
            decoration: const InputDecoration(labelText: 'Estoque Mínimo'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Campo obrigatório';
              if (double.tryParse(value) == null) return 'Valor inválido';
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.initialProduto == null ? 'Criar Produto' : 'Atualizar Produto'),
          ),
        ],
      ),
    );
  }
}
