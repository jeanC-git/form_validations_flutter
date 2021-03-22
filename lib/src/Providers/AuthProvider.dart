import 'package:form_validation/src/preferencias_usuario/PreferenciasUsuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:form_validation/src/utils/RoutesProviders.dart' as routes;

class AuthProvider {
  String _url = routes.authUrl;

  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      "email": email,
      "password": password,
    };

    final resp = await http.post('$_url/login', body: authData);
    final Map<String, dynamic> data = json.decode(resp.body);
    _prefs.usToken = data['token'];

    return {'ok': true, 'token': data['token']};
  }

  Future<Map<String, dynamic>> registrarUsuario(
      String email, String password) async {
    final authData = {
      "name": "Test",
      "email": email,
      "password": password,
      "password_confirmation": password
    };

    final resp = await http.post('$_url/registro', body: authData);
    final Map<String, dynamic> data = json.decode(resp.body);
    return {'ok': true, 'token': data['token']};
  }
}
