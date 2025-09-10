class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  // Convertir JSON a Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
    );
  }

  // Para enviar en UpdateProduct
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "category": category,
    };
  }

  // Para enviar en CreateProduct (sin id)
  Map<String, dynamic> toJsonRequest() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "category": category,
    };
  }
}
