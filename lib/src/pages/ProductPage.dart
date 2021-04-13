import 'package:flutter/material.dart';
import 'dart:io';

import 'package:form_validation/src/Models/ProductModel.dart';
import 'package:form_validation/src/bloc/Provider.dart';
import 'package:form_validation/src/utils/Utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  ProductModel producto = ProductModel();
  bool _guardando = false;
  PickedFile photo;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
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
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
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
    return ElevatedButton.icon(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        // color: Colors.deepPurple,
        // textColor: Colors.white,
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
    String msg = '';
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });

    if (photo != null && File(photo.path) != null) {
      producto.photoUri = await productosBloc.subirFoto(File(photo.path));
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
      msg = 'Registro guardado';
    } else {
      productosBloc.editarProducto(producto);
      msg = 'Registro actualizado';
    }
    utils.mostrarSnackBar(context, msg);
    Navigator.pop(context);
  }

  Widget _mostrarFoto() {
    if (producto.photoUri != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: producto.photoUri != ''
            ? NetworkImage(producto.photoUri)
            : AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (photo != null) {
        return Image.file(
          File(photo.path),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _processImage(ImageSource.gallery);
  }

  _tomarFoto() {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource type) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: type,
    );

    // Para manejar el error al cancelar la seleccion de una foto
    try {
      photo = PickedFile(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    // Si el usuario cancelo o no selecciona una foto

    if (photo != null) {
      producto.photoUri = null;
    }
    setState(() {});
  }
}
