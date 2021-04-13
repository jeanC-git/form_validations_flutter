import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:form_validation/src/Models/ProductModel.dart';
import 'package:form_validation/src/Services/ProductsService.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosService = new ProductsService();

  Stream<List<ProductModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productosService.cargarProducts();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await _productosService.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  void editarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await _productosService.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(int id) async {
    await _productosService.borrarProducto(id);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosService.subirImage(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}
