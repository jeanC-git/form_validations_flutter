import 'package:flutter/material.dart';
import 'package:form_validation/src/Models/ProductModel.dart';
import 'package:form_validation/src/Providers/ProductsProvider.dart';
import 'package:form_validation/src/utils/Utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productProvider = ProductsProvider();
  bool _guardando = false;
  ProductModel producto = ProductModel();

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual), onPressed: () {}),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton()
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.price.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.price = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Sólo números.';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        onPressed: (_guardando) ? null : _submit);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.available == 1 ? true : false,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              producto.available = (value) ? 1 : 0;
            }));
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    if (producto.id == null) {
      await productProvider.crearProducto(producto);
    } else {
      await productProvider.editarProducto(producto);
    }

    mostrarSnackBar('Registro guardado');
    Navigator.pushNamed(context, 'home');
  }

  void mostrarSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
