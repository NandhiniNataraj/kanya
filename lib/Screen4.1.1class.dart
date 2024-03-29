class GetRooms {
  bool? success;
  List<RoomsDetails>? roomsDetails;

  GetRooms({this.success, this.roomsDetails});

  GetRooms.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['roomsDetails'] != null) {
      roomsDetails = <RoomsDetails>[];
      json['roomsDetails'].forEach((v) {
        roomsDetails!.add(new RoomsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.roomsDetails != null) {
      data['roomsDetails'] = this.roomsDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomsDetails {
  int? roomId;
  String? roomNo;
  String? price;

  RoomsDetails({this.roomId, this.roomNo, this.price});

  RoomsDetails.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    roomNo = json['roomNo'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['roomNo'] = this.roomNo;
    data['price'] = this.price;
    return data;
  }
}
