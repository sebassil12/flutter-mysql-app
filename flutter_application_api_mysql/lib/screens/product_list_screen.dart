// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/models/product_model.dart';
import '/screens/product_detail_screen.dart';
import '/services/product_service.dart';
import '/services/category_service.dart';
import '/models/category_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  final CategoryService _categoryService = CategoryService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
    _loadCategories();
  }

  Future<List<Product>> _loadProducts() async {
    final products = await _productService.getProducts();
    final productList = products.map((p) => Product.fromJson(p)).toList();
    _allProducts = productList;
    _filteredProducts = productList;
    return productList;
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryService.getCategory();
    setState(() {
      _categories = categories.map((c) => Category.fromJson(c)).toList();
    });
  }

  String _getCategoryName(int id) {
    final category = _categories.firstWhere(
      (cat) => cat.idCategoria == id
    );
    return category.nombre;
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _loadProducts();
    });
  }

  //Function to filter products based on search query, allows search by name of product or category name
  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameMatch = product.nombre.toLowerCase().contains(query.toLowerCase());
        final categoryName = _getCategoryName(product.categoria?? 0).toLowerCase();
        final categoryMatch = categoryName.contains(query.toLowerCase());
        return nameMatch || categoryMatch;
      }).toList();
    });
  }


  void _navigateToDetail(Product? product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );

    if (result == true) {
      _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar productos',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _filterProducts(value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay productos disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(product.nombre),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\$${product.precio.toStringAsFixed(2)}'),
                              Text(
                              'Categoría: ${_getCategoryName(product.categoria ?? 0)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _navigateToDetail(product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteProduct(product),
                              ),
                            ],
                          ),
                          onTap: () => _navigateToDetail(product),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que deseas eliminar el producto ${product.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _productService.deleteProduct(product.idProducto.toString());
        _refreshProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }
}