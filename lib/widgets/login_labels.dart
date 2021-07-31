import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  const Labels({Key? key, required this.ruta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // si la ruta es hacia login estoy en el registro
      Text(ruta == 'login' ? 'Ya tienes cuenta?' : 'No tienes cuenta?',
          style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300)),
      const SizedBox(height: 10),
      GestureDetector(
          onTap: () {
            // pushReplacementNamed -> no voy a poder volver atras porque reemplaza la ruta anterior
            Navigator.pushReplacementNamed(context, ruta);
          },
          // si la ruta es hacia login estoy en el registro
          child: Text(
              ruta == 'login'
                  ? 'Ingresa con tu cuenta aquí'
                  : 'Crea una cuenta aquí',
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold)))
    ]);
  }
}
