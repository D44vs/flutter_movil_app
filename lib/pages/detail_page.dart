import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'form_page.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${product.id}"),
            const SizedBox(height: 8),
            Text("Nombre: ${product.name}"),
            const SizedBox(height: 8),
            Text("Descripción: ${product.description}"),
            const SizedBox(height: 8),
            Text("Precio: \$${product.price.toStringAsFixed(0)}"),
            const SizedBox(height: 8),
            Text("Categoría: ${product.category}"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FormPage(product: product)),
                    );
                    if (updated == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await ApiService.deleteProduct(product.id);
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Eliminar"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
