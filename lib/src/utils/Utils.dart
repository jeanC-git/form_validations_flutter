import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void mostrarSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: 1500),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void mostrarSnackBarConCircleProgress(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(msg),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      ],
    ),
    backgroundColor: Color(0xffffae88),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informacion incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}
