import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/LoginBloc.dart';

class Provider extends InheritedWidget {
  static Provider _instacia;

  factory Provider({Key key, Widget child}) {
    if (_instacia == null) {
      _instacia = Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instacia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  final loginBloc = LoginBloc();
  // Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
