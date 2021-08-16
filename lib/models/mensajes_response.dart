import 'dart:convert';

import 'package:chat/models/mensaje.dart';

MessagesResponse messagesResponseFromJson(String str) => MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) => json.encode(data.toJson());

class MessagesResponse {
    MessagesResponse({
        required this.ok,
        required this.msg,
        required this.messages,
    });

    bool ok;
    String msg;
    List<Message> messages;

    factory MessagesResponse.fromJson(Map<String, dynamic> json) => MessagesResponse(
        ok: json["ok"],
        msg: json["msg"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    };
}