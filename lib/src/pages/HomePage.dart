import 'package:flutter/material.dart';
import 'package:form_validation/src/Models/ProductModel.dart';
import 'package:form_validation/src/bloc/Provider.dart';

import 'package:form_validation/src/utils/Utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);

    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(title: Text('CRUD Productos')),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, "producto")
          .then((value) => setState(() {})),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) =>
                _crearItem(context, productosBloc, productos[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(
      BuildContext context, ProductosBloc productosBloc, producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direccion) {
          productosBloc.borrarProducto(producto.id);
          utils.mostrarSnackBar(context, 'Producto eliminado');
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.photoUri == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(producto.photoUri),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text(
                    '${producto.title} - ${producto.price} - Disponible : ${producto.available}'),
                subtitle: Text(producto.id.toString()),
                onTap: () => Navigator.pushNamed(context, "producto",
                        arguments: producto)
                    .then((value) => setState(() {})),
              ),
            ],
          ),
        ));
  }
}
