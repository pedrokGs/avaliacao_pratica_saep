class Produto {
  final String id;
  final String model;
  final String name;
  final String material;
  final double weight;
  final double size;
  final double tension;
  final double currentStock;
  final double minStock;

  const Produto ({
    required this.id,
    required this.model,
    required this.name,
    required this.material,
    required this.weight,
    required this.size,
    required this.tension,
    required this.currentStock,
    required this.minStock,
  });

  Produto copyWith({
    String? id,
    String? model,
    String? name,
    String? material,
    double? weight,
    double? size,
    double? tension,
    double? currentStock,
    double? minStock,
  }){
    return Produto(
      id: id ?? this.id,
      model: model ?? this.model,
      name: name ?? this.name,
      material: material ?? this.material,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      tension: tension ?? this.tension,
      currentStock: currentStock ?? this.currentStock,
      minStock: minStock ?? this.minStock,
    );
  }
}
