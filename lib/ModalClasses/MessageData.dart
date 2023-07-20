// ignore_for_file: file_names

class MessageData {
  String? customerName;
  String? senderId;
  String? tailorName;
  String? receiverId;
  String? tailorId;
  String? customerId;
  String? message;
  String? timeStamp;
  String? customerPic;
  String? tailorPic;
  MessageData({
    this.customerName,
    this.senderId,
    this.tailorName,
    this.receiverId,
    this.tailorId,
    this.customerId,
    this.message,
    this.timeStamp,
    this.customerPic,
    this.tailorPic,
  });
  Map<String, dynamic> toMap() {
    return {
      'CustomerName': customerName,
      'SenderId': senderId,
      'TailorName': tailorName,
      'ReceiverId': receiverId,
      'TailorId': tailorId,
      'CustomerId': customerId,
      'Message': message,
      'TimeStamp': timeStamp,
      'CustomerPic': customerPic,
      'TailorPic': tailorPic,
    };
  }

  factory MessageData.fromMap(Map<dynamic, dynamic> map) {
    return MessageData(
      customerName: map['CustomerName'],
      senderId: map['SenderId'],
      tailorName: map['TailorName'],
      receiverId: map['ReceiverId'],
      tailorId: map['TailorId'],
      customerId: map['CustomerId'],
      message: map['Message'],
      timeStamp: map['TimeStamp'],
      customerPic: map['CustomerPic'],
      tailorPic: map['TailorPic'],
    );
  }
}
