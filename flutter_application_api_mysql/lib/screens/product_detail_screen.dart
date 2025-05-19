// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/models/product_model.dart';
import '/services/product_service.dart';
import '/services/category_service.dart';
import '/models/category_model.dart';
class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  late Future<List<Category>> _categoriesFuture;
  
  late String _codigoBarra;
  late String _nombre;
  late int _categoria;
  late String _marca;
  late double _precio;

  @override
  void initState() {
    super.initState();
    _codigoBarra = widget.product?.codigoBarra ?? '';
    _nombre = widget.product?.nombre ?? '';
    _categoria = widget.product?.categoria ?? 0;
    _marca = widget.product?.marca ?? '';
    _precio = widget.product?.precio ?? 0.0;
    _categoriesFuture = _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    final categories = await _categoryService.getCategory();
    return categories.map((c) => Category.fromJson(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Nuevo Producto' : 'Editar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _codigoBarra,
                decoration: const InputDecoration(
                  labelText: 'Código de Barras',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _codigoBarra = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
                onChanged: (value) => _nombre = value,
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error al cargar categorías');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No hay categorías disponibles');
                  } else {
                    final categories = snapshot.data!;
                    return DropdownButtonFormField<int>(
                      value: _categoria == 0 ? null : _categoria,
                      decoration: const InputDecoration(
                        labelText: 'Categoría*',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map((cat) => DropdownMenuItem<int>(
                                value: cat.idCategoria,
                                child: Text(cat.nombre),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione la categoría';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _categoria = value;
                          });
                        }
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _marca,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _marca = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _precio.toString(),
                decoration: const InputDecoration(
                  labelText: 'Precio*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    _precio = parsed;
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'CodigoBarra': _codigoBarra.isEmpty ? null : _codigoBarra,
        'Nombre': _nombre,
        'Categoria': _categoria.isNaN ? null : _categoria,
        'Marca': _marca.isEmpty ? null : _marca,
        'Precio': _precio,
      };

      try {
        if (widget.product == null) {
          await _productService.createProduct(productData);
        } else {
          await _productService.updateProduct(
              widget.product!.idProducto.toString(), productData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto guardado correctamente')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }
}