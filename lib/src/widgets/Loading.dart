import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/Provider.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return StreamBuilder(
      stream: bloc.cargando,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Visibility(
          visible: (snapshot.hasData && snapshot.data),
          child: Stack(children: <Widget>[
            Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.transparent),
                color: Colors.white.withOpacity(
                    0.4), // Specifies the background color and the opacity
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image(
                    image: AssetImage('assets/loader.gif'),
                  ),
                )
              ],
            )
          ]),
        );
      },
    );
  }
}
