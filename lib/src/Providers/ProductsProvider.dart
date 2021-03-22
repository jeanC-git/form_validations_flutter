import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:form_validation/src/Models/ProductModel.dart';
import 'package:form_validation/src/utils/RoutesProviders.dart' as routes;
import 'package:form_validation/src/preferencias_usuario/PreferenciasUsuario.dart';

class ProductsProvider {
  final String _url = '${routes.apiUrl}/productos';
  final _prefs = new PreferenciasUsuario();

  Future<List<ProductModel>> cargarProducts() async {
    final url = '$_url/index';
    final resp = await http.get(url, headers: _setHeaders());
    final decodedData = json.decode(resp.body);
    final List<ProductModel> productos = [];
    decodedData['productos'].forEach((value) {
      final prodTemp = ProductModel.fromJson(value);
      productos.add(prodTemp);
    });
    return productos;
  }

  Future<String> crearProducto(ProductModel producto) async {
    final url = '$_url/crear';
    final resp = await http.post(url,
        body: productModelToJson(producto), headers: _setHeaders());
    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData['msg'];
  }

  Future<bool> editarProducto(ProductModel producto) async {
    final url = '$_url/editar/${producto.id}';
    final resp = await http.put(url,
        body: productModelToJson(producto), headers: _setHeaders());
    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<String> borrarProducto(int id) async {
    final url = '$_url/eliminar/$id';
    final resp = await http.delete(url, headers: _setHeaders());
    final decodedData = json.decode(resp.body);
    return decodedData['msg'];
  }

  Future<String> subirImage(File imagen) async {
    final url = Uri.parse(routes.getUploadUrlByTypeFile('image'));
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.usToken}'
      };
}
