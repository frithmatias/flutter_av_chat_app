import 'package:chat/global/environment.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuariosService with ChangeNotifier {

  UsuariosService(){
    //getUsuarios();
  }

  Future<List<Usuario>> getUsuarios() async {
    try {

      final token = await AuthService.getToken();
      final url = Uri.parse(Environments.apiUrl + '/users');
      final resp = await http.get(url, headers: {'Content-Type': 'application/json', 'x-token': token});

      if (resp.statusCode == 200) {
        final loginResponse = usuariosResponseFromJson(resp.body);
        // notifyListeners(); // Como la propiedad o la lista de usuarios no la tengo en el servicio, sino que 
        // la tengo en la página usuarios, no me sirve notifyListeners(), tengo que hacer un setState() en 
        // el widget o la página de usuarios, que es un StatefulWidget.
        return loginResponse.users;
      } else {
        return [];
      }

    } catch(err) {
      return [];
    }
  }
}