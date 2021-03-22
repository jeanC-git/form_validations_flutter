import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/Provider.dart';
import 'package:form_validation/src/pages/HomePage.dart';
import 'package:form_validation/src/pages/LoginPage.dart';
import 'package:form_validation/src/pages/ProductPage.dart';
import 'package:form_validation/src/pages/RegistroPage.dart';
import 'package:form_validation/src/preferencias_usuario/PreferenciasUsuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print('Token Usuario');
    print(prefs.usToken);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
