class Menu {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String category;

  Menu({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.category,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'description': description,
        'category': category,
      };
}
