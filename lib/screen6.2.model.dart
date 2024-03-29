class BookingDetails {
  bool? success;
  List<RoomBookingsDetails>? roomBookingsDetails;

  BookingDetails({this.success, this.roomBookingsDetails});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['roomBookingsDetails'] != null) {
      roomBookingsDetails = <RoomBookingsDetails>[];
      json['roomBookingsDetails'].forEach((v) {
        roomBookingsDetails!.add(new RoomBookingsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.roomBookingsDetails != null) {
      data['roomBookingsDetails'] =
          this.roomBookingsDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomBookingsDetails {
  int? bookingId;
  int? roomId;
  String? roomNo;
  String? roomPrice;
  String? name;
  String? mobileNo;
  String? totalAmount;
  String? received;
  String? balance;

  RoomBookingsDetails(
      {this.bookingId,
        this.roomId,
        this.roomNo,
        this.roomPrice,
        this.name,
        this.mobileNo,
        this.totalAmount,
        this.received,
        this.balance});

  RoomBookingsDetails.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    roomId = json['roomId'];
    roomNo = json['roomNo'];
    roomPrice = json['roomPrice'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    totalAmount = json['totalAmount'];
    received = json['received'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['roomId'] = this.roomId;
    data['roomNo'] = this.roomNo;
    data['roomPrice'] = this.roomPrice;
    data['name'] = this.name;
    data['mobileNo'] = this.mobileNo;
    data['totalAmount'] = this.totalAmount;
    data['received'] = this.received;
    data['balance'] = this.balance;
    return data;
  }
}