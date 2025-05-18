class Product {
  final int idProducto;
  final String? codigoBarra;
  final String nombre;
  final String? categoria;
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
      codigoBarra: json['CodigoBarra'],
      nombre: json['Nombre'],
      categoria: json['Categoria'],
      marca: json['Marca'],
      precio: double.parse(json['Precio'].toString()),
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