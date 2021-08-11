class Usuario {
  bool blOnline;
  String txEmail;
  String txName;
  String txUid;

  Usuario({
    required this.blOnline,
    required this.txEmail,
    required this.txName,
    required this.txUid,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        blOnline: json["blOnline"],
        txName: json["txName"],
        txEmail: json["txEmail"],
        txUid: json["txUid"],
      );

  Map<String, dynamic> toJson() => {
        "blOnline": blOnline,
        "txName": txName,
        "txEmail": txEmail,
        "txUid": txUid,
      };
}
