import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:form_validation/src/Models/ProductModel.dart';

class ProductsProvider {
  final String _url = 'https://jc-backend-flutter.herokuapp.com/api';

  Future<String> crearProducto(ProductModel producto) async {
    final url = '$_url/create_product';
    final resp = await http.post(url,
        body: productModelToJson(producto), headers: _setHeaders());
    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData['msg'];
  }

  Future<List<ProductModel>> cargarProducts() async {
    final url = '$_url/products';
    final resp = await http.get(url, headers: _setHeaders());
    final decodedData = json.decode(resp.body);
    final List<ProductModel> productos = [];

    decodedData.forEach((value) {
      // print(value["price"].runtimeType);
      final prodTemp = ProductModel.fromJson(value);
      productos.add(prodTemp);
    });
    print(productos);
    return productos;
  }

  Future<String> borrarProducto(int id) async {
    final url = '$_url/delete_product/$id';
    final resp = await http.delete(url, headers: _setHeaders());
    final decodedData = json.decode(resp.body);
    // print(decodedData['msg']);

    return decodedData['msg'];
  }

  Future<bool> editarProducto(ProductModel producto) async {
    final url = '$_url/editar_product/${producto.id}';
    final resp = await http.post(url,
        body: productModelToJson(producto), headers: _setHeaders());
    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization' : 'Bearer $token'
      };
}
