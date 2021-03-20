import 'package:flutter/material.dart';
import 'package:form_validation/src/Models/ProductModel.dart';
import 'package:form_validation/src/Providers/ProductsProvider.dart';
import 'package:form_validation/src/bloc/Provider.dart';

class HomePage extends StatelessWidget {
  final productosProvider = ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('CRUD Productos')),
      body: _crearListado(),
      floatingActionButton: _crearFloating(context),
    );
  }

  Widget _crearFloating(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product'),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.cargarProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion) {
        // Borrar producto from BD
        productosProvider.borrarProducto(producto.id);
      },
      child: ListTile(
        title: Text(
            '${producto.title} - ${producto.price} - Disponible : ${producto.available}'),
        subtitle: Text(producto.id.toString()),
        onTap: () =>
            Navigator.pushNamed(context, 'product', arguments: producto),
      ),
    );
  }
}
