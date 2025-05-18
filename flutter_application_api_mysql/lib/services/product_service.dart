import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  // La app movil toma a localhost como su propio dispositivo
  // static const String _baseUrl = 'http://localhost:3000/api/products';
  // Dirección que reconocen los emuladores AS como la pc host
  static const String _baseUrl = 'http://localhost:3000/api/products';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json'
  };

  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  Future<dynamic> getProductById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar el producto');
    }
  }

  Future<dynamic> createProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: json.encode(product),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear el producto');
    }
  }

  Future<dynamic> updateProduct(String id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
      body: json.encode(product),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al actualizar el producto');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el producto');
    }
  }
}