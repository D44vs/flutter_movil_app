import 'dart:convert';
import 'package:flutter_movil_app/pages/homepage.dart';
import 'package:http/http.dart' as http;
// import 'main.dart'; // para usar la clase Item

class ApiService {
  static const String baseUrl = 'https://localhost:7232/api/comidas'; // tu Swagger

  static Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Item(
        id: json['id'],
        name: json['name'],
        description: json['description'],
      )).toList();
    } else {
      throw Exception('Error al obtener items');
    }
  }

  static Future<Item> addItem(Item item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': item.name, 'description': item.description}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Item(id: json['id'], name: json['name'], description: json['description']);
    } else {
      throw Exception('Error al agregar item');
    }
  }

  static Future<Item> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': item.id, 'name': item.name, 'description': item.description}),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return item;
    } else {
      throw Exception('Error al actualizar item');
    }
  }

  static Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar item');
    }
  }
}
