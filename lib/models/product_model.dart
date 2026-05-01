import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String nombre;
  final double precio;
  final String categoria;
  final String descripcion;
  final int stock;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.descripcion,
    required this.stock,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      nombre: data['Nombre'] ?? '',
      precio: (data['Precio'] ?? 0).toDouble(),
      categoria: data['categoria'] ?? '',
      descripcion: data['descripcion'] ?? '',
      stock: data['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Nombre': nombre,
      'Precio': precio,
      'categoria': categoria,
      'descripcion': descripcion,
      'stock': stock,
    };
  }
}
