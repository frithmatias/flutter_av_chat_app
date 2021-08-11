// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';
import 'package:chat/models/usuario.dart';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
        required this.ok,
        required this.msg,
        required this.user,
        required this.token,
    });

    bool ok;
    String msg;
    Usuario user;
    String token;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        ok: json["ok"],
        msg: json["msg"],
        user: Usuario.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "user": user.toJson(),
        "token": token,
    };
}


