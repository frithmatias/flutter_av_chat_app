// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;

  // Create storage
  final _storage = const FlutterSecureStorage();

  // Voy a crear métodos estáticos para manejar el token desde afuera
  // (Future porque la lectura no es síncrona)

  static Future<String> getToken() async {
    // Cómo es ESTATICA NO TENGO acceso a las propiedades de la clase como _storage.
    const _storage = FlutterSecureStorage(); // creo otra instancia nuevamente
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage(); // creo otra instancia nuevamente
    await _storage.delete(key: 'token');
  }

  bool _isWaiting = false;
  bool get waiting => _isWaiting;
  set waiting(bool state) {
    _isWaiting = state;
    // todos los widgets que esperan cambios de este servicio se van a REDIBUJAR cuando alguna propiedad cambie
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    waiting = true;

    final data = {'email': email, 'password': password};

    final url = Uri.parse(Environments.apiUrl + '/auth/login');
    final resp =
        await http.post(url, body: jsonEncode(data), // import 'dart:convert';
            headers: {'Content-Type': 'application/json'});

    waiting = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginFromJson(resp.body);
      usuario = loginResponse.user;
      await _guardarToken(loginResponse.token);
      return true;
    }

    return false;
  }

  Future<bool> register(String name, String email, String password) async {

    waiting = true;

    final data = {'name': name, 'email': email, 'password': password};
    final url = Uri.parse(Environments.apiUrl + '/auth/register');
    final resp = await http.post(
      url, 
      body: jsonEncode(data), // import 'dart:convert';
      headers: {'Content-Type': 'application/json'}
    );

    waiting = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginFromJson(resp.body);
      usuario = loginResponse.user;
      await _guardarToken(loginResponse.token);
      return true;
    }

    return false;
  }

  Future<bool> isLogged() async {
    // waiting = true;

    final token = await _storage.read(key: 'token');
    print('TOKEN: $token');
    // verifico el token contra el API localhost:3000/api/auth/newtoken
    if(token == null) return false;

    final url = Uri.parse(Environments.apiUrl + '/auth/newtoken');
    final resp =
        await http.get(url, // import 'dart:convert';
            headers: {
              'Content-Type': 'application/json',
              'x-token': token
            });

    // waiting = false;
    // la petición va a pasar por el middleware verificaToken, si pasa el middleware va a ejecutar 
    // newToken que me va a devolver un nuevo token.
    if (resp.statusCode == 200) {
      final loginResponse = loginFromJson(resp.body);
      usuario = loginResponse.user;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }

  }

  Future _guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
