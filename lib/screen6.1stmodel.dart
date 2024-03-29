class PaymentMode {
  bool? success;
  List<PaymentModesDetails>? paymentModesDetails;

  PaymentMode({this.success, this.paymentModesDetails});

  PaymentMode.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['paymentModesDetails'] != null) {
      paymentModesDetails = <PaymentModesDetails>[];
      json['paymentModesDetails'].forEach((v) {
        paymentModesDetails!.add(new PaymentModesDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.paymentModesDetails != null) {
      data['paymentModesDetails'] =
          this.paymentModesDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentModesDetails {
  int? paymentModeId;
  String? paymentMode;

  PaymentModesDetails({this.paymentModeId, this.paymentMode});

  PaymentModesDetails.fromJson(Map<String, dynamic> json) {
    paymentModeId = json['paymentModeId'];
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentModeId'] = this.paymentModeId;
    data['paymentMode'] = this.paymentMode;
    return data;
  }
}