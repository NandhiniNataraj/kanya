class Book {
  bool? success;
  List<AvailRoomsByDate>? availRoomsByDate;

  Book({this.success, this.availRoomsByDate});

  Book.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['availRoomsByDate'] != null) {
      availRoomsByDate = <AvailRoomsByDate>[];
      json['availRoomsByDate'].forEach((v) {
        availRoomsByDate!.add(new AvailRoomsByDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.availRoomsByDate != null) {
      data['availRoomsByDate'] =
          this.availRoomsByDate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailRoomsByDate {
  String? roomNo;
  String? price;

  AvailRoomsByDate({this.roomNo, this.price});

  AvailRoomsByDate.fromJson(Map<String, dynamic> json) {
    roomNo = json['roomNo'];
    price = json['price'];
  }

  get success => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomNo'] = this.roomNo;
    data['price'] = this.price;
    return data;
  }
}
