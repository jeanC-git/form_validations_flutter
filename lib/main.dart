import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/Provider.dart';
import 'package:form_validation/src/pages/HomePage.dart';
import 'package:form_validation/src/pages/LoginPage.dart';
import 'package:form_validation/src/pages/ProductPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
