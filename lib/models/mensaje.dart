class Message {
    Message({
        required this.idFrom,
        required this.idTo,
        required this.txMessage,
        required this.createdAt,
        required this.updatedAt,
    });

    String idFrom;
    String idTo;
    String txMessage;
    DateTime createdAt;
    DateTime updatedAt;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        idFrom: json["idFrom"],
        idTo: json["idTo"],
        txMessage: json["txMessage"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "idFrom": idFrom,
        "idTo": idTo,
        "txMessage": txMessage,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}