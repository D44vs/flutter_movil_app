// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/product.dart';

// class ApiService {
//   final String baseUrl = "http://localhost:7059/Product";
//   // ⚠️ Cambia el puerto al que Swagger te muestre

//   Future<List<Product>> getProducts() async {
//     final response = await http.get(Uri.parse("$baseUrl/GetProducts"));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((item) => Product.fromJson(item)).toList();
//     } else {
//       throw Exception("Error al obtener productos");
//     }
//   }

//   Future<Product> createProduct(Product product) async {
//   final response = await http.post(
//     Uri.parse("$baseUrl/CreateProduct"),
//     headers: {"Content-Type": "application/json"},
//     body: json.encode({
//       "name": product.name,
//       "description": product.description,
//       "price": product.price,
//       "category": product.category
//     }),
//   );

//   if (response.statusCode == 200) {
//     return Product.fromJson(json.decode(response.body));
//   } else {
//     throw Exception("Error al crear producto: ${response.body}");
//   }
// }


//   Future<Product> updateProduct(Product product) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/UpdateProduct"),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode(product.toJson()),
//     );
//     if (response.statusCode == 200) {
//       return Product.fromJson(json.decode(response.body));
//     } else {
//       throw Exception("Error al actualizar producto");
//     }
//   }

//   Future<void> deleteProduct(int id) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/DeleteProduct"),
//       headers: {"id": id.toString()},
//     );
//     if (response.statusCode != 200) {
//       throw Exception("Error al eliminar producto");
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // 👉 Usa HTTP (no HTTPS) para evitar problemas de certificado
  static const String baseUrl = "http://localhost:5059/Product";

  // GET: traer productos
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/GetProducts"));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar productos: ${response.statusCode}");
    }
  }

  // POST: crear producto
  static Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse("$baseUrl/CreateProduct"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJsonRequest()), // usa RequestProduct
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al crear producto");
    }
  }

  // POST: actualizar producto
  static Future<Product> updateProduct(Product product) async {
    final response = await http.post(
      Uri.parse("$baseUrl/UpdateProduct"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al actualizar producto");
    }
  }

  // POST: eliminar producto
  static Future<void> deleteProduct(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/DeleteProduct"),
      headers: {"id": id.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar producto");
    }
  }
}
