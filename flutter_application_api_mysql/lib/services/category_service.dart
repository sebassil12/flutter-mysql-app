import 'dart:convert';
import 'package:flutter_application_13_api_mysql/services/config_service.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  // La app movil toma a localhost como su propio dispositivo
  // static const String _baseUrl = 'http://localhost:3000/api/products';
  // Dirección que reconocen los emuladores AS como la pc host
  static const String _baseUrl = '${AppConfig.baseUrl}/api/category';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json'
  };

  Future<List<dynamic>> getCategory() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar las categorias');
    }
  }

  Future<dynamic> getCategoryById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar la categoria');
    }
  }

  Future<dynamic> createCategory(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: json.encode(product),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear la categoria');
    }
  }

  Future<dynamic> updateCategory(String id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
      body: json.encode(product),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al actualizar la categoria');
    }
  }

  Future<void> deleteCategory(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la categoria');
    }
  }
}