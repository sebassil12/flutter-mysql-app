class Product {
  final int idProducto;
  final String? codigoBarra;
  final String nombre;
  final int? categoria;
  final String? marca;
  final double precio;

  Product({
    required this.idProducto,
    this.codigoBarra,
    required this.nombre,
    this.categoria,
    this.marca,
    required this.precio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProducto: json['IdProducto'],
      codigoBarra: json['codigoBarra'],
      nombre: json['nombre'],
      categoria: json['categoria_id'],
      marca: json['marca'],
      precio: double.parse(json['precio'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodigoBarra': codigoBarra,
      'Nombre': nombre,
      'Categoria': categoria,
      'Marca': marca,
      'Precio': precio,
    };
  }
}