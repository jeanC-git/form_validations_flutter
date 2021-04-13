import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:form_validation/src/Services/AuthService.dart';
import 'package:form_validation/src/bloc/Validators.dart';

class LoginBloc with Validators {
  final _authService = new AuthService();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _cargandoController = new BehaviorSubject<bool>();

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _cargandoController?.close();
  }

  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);
  Stream<bool> get cargando => _cargandoController.stream;

  // Insert valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  // Métodos
  Future<bool> login(String email, String password) async {
    _cargandoController.sink.add(true);
    final login = await _authService.login(email, password);
    await Future.delayed(const Duration(milliseconds: 2500));
    _cargandoController.sink.add(false);
    return login['ok'];
  }

  void setTrueCargando() {
    _cargandoController.sink.add(true);
  }
}
