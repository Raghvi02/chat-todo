class ChatMessage {
  final String msg;
  final String toId;
  final String read;
  final Type type;
  final String fromId;
  final String sent;
  final String cid;

  ChatMessage({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    required this.cid,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      msg: json['msg'].toString(),
      toId: json['toId'].toString(),
      read: json['read'].toString(),
      type: json['type'].toString()== Type.image.name? Type.image: Type.text,
      fromId: json['fromId'].toString(),
      sent: json['sent'].toString(),
      cid: json['cid'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'toId': toId,
      'read': read,
      'type': type.name,
      'fromId': fromId,
      'sent': sent,
      'cid': cid,
    };

  }


}
enum Type{text, image}