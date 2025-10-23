import 'package:sistema/features/products/domain/entity/produto.dart';

class ProdutoModel {
  final String? id;
  final String model;
  final String name;
  final String material;
  final double weight;
  final double size;
  final double tension;
  final double currentStock;
  final double minStock;

  const ProdutoModel({
    this.id,
    required this.model,
    required this.name,
    required this.material,
    required this.weight,
    required this.size,
    required this.tension,
    required this.currentStock,
    required this.minStock,
  });

  factory ProdutoModel.fromJson(Map<String, dynamic> map) {
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProdutoModel(
      id: map['id'] ?? '',
      model: map['model'] ?? '',
      name: map['name'] ?? '',
      material: map['material'] ?? '',
      weight: parseDouble(map['weight']),
      size: parseDouble(map['size']),
      tension: parseDouble(map['tension']),
      currentStock: parseDouble(map['currentStock']),
      minStock: parseDouble(map['minStock']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "model": model,
      "name": name,
      "material": material,
      "weight": weight,
      "size": size,
      "tension": tension,
      "currentStock": currentStock,
      "minStock": minStock,
    };
  }

  Produto toEntity() {
    return Produto(
      id: id ?? '',
      model: model,
      name: name,
      material: material,
      weight: weight,
      size: size,
      tension: tension,
      currentStock: currentStock,
      minStock: minStock,
    );
  }
}
