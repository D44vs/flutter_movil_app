import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class FormPage extends StatefulWidget {
  final Product? product;
  const FormPage({super.key, this.product});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController categoryCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product?.name ?? "");
    descCtrl = TextEditingController(text: widget.product?.description ?? "");
    priceCtrl =
        TextEditingController(text: widget.product?.price.toString() ?? "");
    categoryCtrl =
        TextEditingController(text: widget.product?.category ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.product == null
              ? "Nuevo Producto"
              : "Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
              TextFormField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Precio"),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese un precio" : null,
              ),
              TextFormField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: "Categoría"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final product = Product(
                      id: widget.product?.id ?? 0,
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      price: double.tryParse(priceCtrl.text) ?? 0,
                      category: categoryCtrl.text,
                    );

                    if (widget.product == null) {
                      await ApiService.createProduct(product);
                    } else {
                      await ApiService.updateProduct(product);
                    }

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
