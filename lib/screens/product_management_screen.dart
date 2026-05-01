import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  // Función para formatear moneda con comas y puntos (ej: 15,202.50)
  String _formatCurrency(double amount) {
    String price = amount.toStringAsFixed(2);
    List<String> parts = price.split('.');
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    String result = parts[0].replaceAllMapped(reg, mathFunc);
    return '$result.${parts[1]}';
  }

  void _showProductDialog({Product? product}) {
    final isEditing = product != null;
    final nombreController = TextEditingController(text: product?.nombre);
    final precioController = TextEditingController(text: product?.precio.toString());
    final categoriaController = TextEditingController(text: product?.categoria);
    final descripcionController = TextEditingController(text: product?.descripcion);
    final stockController = TextEditingController(text: product?.stock.toString());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2E6DA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            SizedBox(
              height: 90,
              child: Lottie.network(
                'https://lottie.host/80517562-6c3e-4f7d-b778-5a7f9d8f8e6c/7Z0A0z8M5u.json',
                repeat: true,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.palette_rounded,
                  size: 60,
                  color: Color(0xFF5D4037),
                ),
              ),
            ),
            Text(
              isEditing ? 'Editar Producto' : 'Nuevo Producto',
              style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
            ),
          ],
        ),
        content: Container(
          width: 310,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nombreController, 'Nombre del Producto', Icons.label_outline),
                _buildTextField(descripcionController, 'Descripción Detallada', Icons.description_outlined, maxLines: 2),
                _buildTextField(categoriaController, 'Categoría', Icons.category_outlined),
                Row(
                  children: [
                    Expanded(child: _buildTextField(precioController, 'Precio', Icons.attach_money_outlined, isNumber: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField(stockController, 'Stock', Icons.inventory_2_outlined, isNumber: true)),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCELAR', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D4037),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final newProduct = Product(
                        id: product?.id ?? '',
                        nombre: nombreController.text,
                        precio: double.tryParse(precioController.text) ?? 0.0,
                        categoria: categoriaController.text,
                        descripcion: descripcionController.text,
                        stock: int.tryParse(stockController.text) ?? 0,
                      );
                      if (isEditing) {
                        _firebaseService.updateProduct(newProduct);
                      } else {
                        _firebaseService.addProduct(newProduct);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(isEditing ? 'GUARDAR' : 'CREAR'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2E6DA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFB71C1C), size: 50),
            const SizedBox(height: 10),
            Text(
              '¿Retirar Producto?',
              style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estás por eliminar definitivamente el siguiente registro:', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 15),
            _buildDetailRow('Nombre:', product.nombre),
            _buildDetailRow('Categoría:', product.categoria),
            _buildDetailRow('Precio:', '\$${_formatCurrency(product.precio)}'),
            _buildDetailRow('Stock actual:', product.stock.toString()),
            const SizedBox(height: 10),
            const Text('Esta acción no se puede deshacer.', style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('MANTENER', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C)),
            onPressed: () {
              _firebaseService.deleteProduct(product.id);
              Navigator.pop(context);
            },
            child: const Text('ELIMINAR DEFINITIVAMENTE', style: TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF5D4037))),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(color: const Color(0xFF5D4037), fontSize: 12),
          prefixIcon: Icon(icon, color: const Color(0xFF8D6E63), size: 18),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF5D4037), width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 16,
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.montserrat(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(value, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  MaterialColor _getStockColor(int stock) {
    if (stock < 5) return Colors.red;
    if (stock <= 15) return Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E6DA),
      body: Column(
        children: [
          // Header
          // Header Estilo Menu
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/header.PNG'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.black.withOpacity(0.3),
              ),
              // Botón de Volver
              Positioned(
                top: 45,
                left: 15,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 26),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Logo en la esquina superior izquierda (desplazado por el botón volver)
              Positioned(
                top: 45,
                left: 65,
                child: Image.network(
                  'https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/logo%20(1).png',
                  height: 60,
                ),
              ),
              // Nombre del negocio centrado
              Container(
                height: 150,
                alignment: Alignment.center,
                child: Text(
                  'ArtStore',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Recuadro Café "Panel de Control"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: const BoxDecoration(
              color: Color(0xFF5D4037),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Panel de Control',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _firebaseService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final products = snapshot.data ?? [];
                
                double totalValue = products.fold(0, (sum, p) => sum + (p.precio * p.stock));
                int lowStock = products.where((p) => p.stock < 5).length;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 850),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildSummaryCard('Total Productos', products.length.toString(), Icons.inventory_2_outlined, const Color(0xFF5D4037)),
                              const SizedBox(width: 8),
                              _buildSummaryCard('Alertas Stock', lowStock.toString(), Icons.warning_amber_rounded, Colors.orange),
                              const SizedBox(width: 8),
                              _buildSummaryCard('Valor Total', '\$${_formatCurrency(totalValue)}', Icons.payments_outlined, Colors.green),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3E2723),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.art_track, color: Colors.white70, size: 20),
                                      const SizedBox(width: 8),
                                      Text('Inventario de Suministros', style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      const Spacer(),
                                      ElevatedButton.icon(
                                        onPressed: () => _showProductDialog(),
                                        icon: const Icon(Icons.add_circle_outline, size: 16),
                                        label: const Text('Agregar Producto', style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF3E2723),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 25,
                                    columns: [
                                      DataColumn(label: Text('Nombre', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12))),
                                      DataColumn(label: Text('Descripción', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12))),
                                      DataColumn(label: Text('Categoría', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12))),
                                      DataColumn(label: Text('Precio', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12))),
                                      DataColumn(label: Text('Stock', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12))),
                                      DataColumn(label: Text('Acciones', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12))),
                                    ],
                                    rows: products.map((p) {
                                      MaterialColor stockColor = _getStockColor(p.stock);
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(p.nombre, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                          DataCell(
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 120),
                                              child: Text(
                                                p.descripcion,
                                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(p.categoria, style: const TextStyle(fontSize: 12))),
                                          DataCell(Text('\$${_formatCurrency(p.precio)}', style: const TextStyle(fontSize: 12))),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: stockColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: stockColor.withOpacity(0.3)),
                                              ),
                                              child: Text(
                                                p.stock.toString(), 
                                                style: TextStyle(color: stockColor.shade900, fontWeight: FontWeight.bold, fontSize: 11)
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              children: [
                                                IconButton(icon: const Icon(Icons.edit_note, color: Colors.blueGrey, size: 20), onPressed: () => _showProductDialog(product: p)),
                                                IconButton(
                                                  icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20), 
                                                  onPressed: () => _showDeleteConfirmation(p)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
