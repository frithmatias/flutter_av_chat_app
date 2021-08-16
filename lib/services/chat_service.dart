import 'package:chat/global/environment.dart';
import 'package:chat/models/mensaje.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Message>> getMessages() async {
    try {

      final token = await AuthService.getToken();
      final url = Uri.parse(Environments.apiUrl + '/messages/${usuarioPara.txUid}');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json', 
        'x-token': token
      });

      if (resp.statusCode == 200) {
        final messagesResponse = messagesResponseFromJson(resp.body);
        return messagesResponse.messages;
      } else {
        return [];
      }
    } catch (err) {
      return [];
    }
  }
}
