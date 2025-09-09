import 'package:flutter/material.dart';
import 'package:flutter_movil_app/services/api_service.dart';

// Modelo
class Item {
  int id;
  String name;
  String description;

  Item({required this.id, required this.name, required this.description});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD App',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];
  List<Item> filteredItems = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems();
    searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchItems() async {
    try {
      items = await ApiService.getItems();
      _filterItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar items: $e')),
      );
    }
  }

  void _filterItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = items
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _goToDetail(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(item: item),
      ),
    );
  }

  Future<void> _goToRegister({Item? itemToEdit}) async {
    final result = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(item: itemToEdit),
      ),
    );

    if (result != null) {
      try {
        if (itemToEdit != null) {
          await ApiService.updateItem(result);
        } else {
          final newItem = await ApiService.addItem(result);
          result.id = newItem.id;
        }
        fetchItems();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar item: $e')),
        );
      }
    }
  }


  void _deleteItem(Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              try {
                await ApiService.deleteItem(item.id);
                fetchItems();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al eliminar item: $e')),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => _goToDetail(item),
                        child: const Text('Detalle'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _goToRegister(itemToEdit: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToRegister(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Detalle
class DetailPage extends StatelessWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(item.description, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// Registro / Edición
class RegisterPage extends StatefulWidget {
  final Item? item;
  const RegisterPage({super.key, this.item});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      descriptionController.text = widget.item!.description;
    }
  }

  void _save() {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) return;

    final newItem = Item(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      description: descriptionController.text,
    );
    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item != null ? 'Editar Objeto' : 'Agregar Objeto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
