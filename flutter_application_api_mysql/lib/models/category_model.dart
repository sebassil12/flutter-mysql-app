class Category {
  final int idCategoria;
  final String nombre;

  Category({
    required this.idCategoria,
    required this.nombre,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategoria: json['IdCategoria'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Nombre': nombre,
    };
  }
}