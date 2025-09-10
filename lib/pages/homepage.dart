import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'detail_page.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> productsFuture;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    refreshProducts();
  }

  void refreshProducts() {
    setState(() {
      productsFuture = ApiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Buscar producto...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("❌ Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay productos"));
                }

                final products = snapshot.data!
                    .where((p) =>
                        p.name.toLowerCase().contains(searchQuery) ||
                        p.category.toLowerCase().contains(searchQuery))
                    .toList();

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.category),
                      trailing: Text("\$${product.price.toStringAsFixed(0)}"),
                      onTap: () async {
                        final updated =
                            await Navigator.push(context, MaterialPageRoute(
                          builder: (_) => DetailPage(product: product),
                        ));
                        if (updated == true) {
                          refreshProducts();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
          if (created == true) {
            refreshProducts();
          }
        },
      ),
    );
  }
}
