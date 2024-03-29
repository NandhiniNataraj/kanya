import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanya/screen4.dart';
import 'package:kanya/screen6.1stmodel.dart';
import 'package:kanya/screen6.2.model.dart';
import 'package:http/http.dart' as http;

class Screen6 extends StatefulWidget {
  const Screen6({super.key});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PaymentModesDetails>? Payment;

  Future<List<PaymentModesDetails>> Getresponse1() async{
    var response = await http.get(Uri.parse("http://92.205.109.210:8055/PaymentMode/GetPaymentModes"));
    var datas = jsonDecode(response.body)["paymentModesDetails"];
    print(datas);
    return (datas as List).map((e) => PaymentModesDetails.fromJson(e)).toList();
  }
  String? selectedValue;


  TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dateController.text = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : '';
    amountcontroller = TextEditingController();
    balancecontroller = TextEditingController();
    Getresponse1();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<List<RoomBookingsDetails>> Getresponse() async{
    var response = await http.get(Uri.parse("http://92.205.109.210:8055/Booking/GetRoomBookings"));
    var datas = jsonDecode(response.body)["roomBookingsDetails"];
    return (datas as List).map((e) => RoomBookingsDetails.fromJson(e)).toList();
  }



  TextEditingController amountcontroller = TextEditingController();
  TextEditingController balancecontroller = TextEditingController();
  TextEditingController remarkscontroller = TextEditingController();

  bool isVisible = false;

  String selectedPaymentModeId = '';

  Future<void> payupdate(String booking, String receive, String payment, String mode, String recedate, String notes) async {
    // EasyLoading.show(status: 'Loading...');
    try {
      var resp = await http.post(
        Uri.parse("http://92.205.109.210:8055/Booking/CollectBalance"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "BookingId": booking,
          "Received": receive,
          "PaymentModeId": selectedPaymentModeId,
          "PaymentMode": mode,
          "ReceivedOn": recedate,
          "Remarks": notes,
          "CreatedBy": 1
        }),
      );

      var dataret = jsonDecode(resp.body);
      print(dataret.toString() + "response");

      if (dataret["success"] == true) {
        // If success is true, show success message
        // EasyLoading.showSuccess(dataret["message"]);
      } else {
        // If success is false, show error message
        // EasyLoading.showError(dataret["errorMessage"]);
      }
    } catch (e) {
      // If an error occurs during the HTTP request, show error message
      // EasyLoading.showError('Failed to perform operation');
      // print("Error: $e");
    } finally {
      // Dismiss the loading indicator regardless of success or failure
      // EasyLoading.dismiss();
    }
  }
  double calculateRemainingBalance(double toPayAmount, double enteredAmount) {
    return toPayAmount - enteredAmount;
  }

  @override
  void dispose() {
    amountcontroller.dispose();
    balancecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>Screen4(),),);
            },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Center(child: Text("Book Screen",style: TextStyle(color:Colors.white),)),
      ),

      body: FutureBuilder<List<RoomBookingsDetails>>(
        future: Getresponse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<RoomBookingsDetails>? list = snapshot.data;
            if (list != null && list.isEmpty) {
              return Center(
                child: Text(
                  "No records found",
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: list!.length,
              itemBuilder: (BuildContext, index) {
                RoomBookingsDetails booking = list[index];
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.name ?? "",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Room No: ${booking.roomNo ?? ""}"),
                            Text("Mobile : ${booking.mobileNo ?? ""}"),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Amount: ${booking.totalAmount ?? ""}"),
                            Text("Balance Amount: ${booking.balance ?? ""}"),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                backgroundColor: Colors.white,
                              ),
                              child: Text("Edit"),
                            ),
                            SizedBox(
                              width: 130,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Form(
                                        key: _formKey,
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 0.7,
                                          width: MediaQuery.of(context).size.width * 1,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 15.0,
                                                spreadRadius: 5.0,
                                                offset: Offset(
                                                  5.0,
                                                  5.0,
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "To Pay:${booking.balance ?? ""}",
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Payment Date",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    style: TextStyle(color: Colors.black),
                                                    readOnly: true,
                                                    onTap: () {
                                                      _selectDate(context);
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      suffixIcon: Icon(Icons.calendar_month),
                                                    ),
                                                    controller: _dateController,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please provide a valid date';
                                                      }
                                                      // You can add more validation here if needed
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("Payment Mode", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // FutureBuilder<List<PaymentModesDetails>>(
                                              //   future: Getresponse1(),
                                              //   builder: (context, snapshot) {
                                              //     if (snapshot.connectionState == ConnectionState.waiting) {
                                              //       return CircularProgressIndicator();
                                              //     } else if (snapshot.hasError) {
                                              //       return Text("${snapshot.error}");
                                              //     } else if (snapshot.hasData) {
                                              //       List<PaymentModesDetails>? paymentModesList = snapshot.data;
                                              //       if (paymentModesList != null) {
                                              //         if (paymentModesList.isEmpty) {
                                              //           return Text("No payment modes available");
                                              //         }
                                              //         return Column(
                                              //           crossAxisAlignment: CrossAxisAlignment.start,
                                              //           children: [
                                              //           Column(
                                              //           crossAxisAlignment: CrossAxisAlignment.start,
                                              //           children: [
                                              //             Container(
                                              //               // width: double.infinity,
                                              //               padding: EdgeInsets.symmetric(horizontal: 10.0),
                                              //               decoration: BoxDecoration(
                                              //                 border: Border.all(color: Colors.black),
                                              //                 borderRadius: BorderRadius.circular(5.0),
                                              //               ),
                                              //               child: DropdownButton(
                                              //                 style: TextStyle(fontSize: 18.0, color: Colors.red),
                                              //                 isExpanded: true,
                                              //                 underline: SizedBox(),
                                              //                 value: selectedValue,
                                              //                 items: paymentModesList.map((item) {
                                              //                   return DropdownMenuItem(
                                              //                     value: item.paymentMode,
                                              //                     child: Text(
                                              //                       item.paymentMode.toString(),
                                              //                       style: TextStyle(color: Colors.red),
                                              //                     ),
                                              //                   );
                                              //                 }).toList(),
                                              //                 onChanged: (value) {
                                              //                   setState(() {
                                              //                     selectedValue = value!;
                                              //                     selectedPaymentModeId = paymentModesList
                                              //                         .firstWhere((item) => item.paymentMode == value)
                                              //                         .paymentModeId!
                                              //                         .toString();
                                              //                   });
                                              //                 },
                                              //
                                              //               ),
                                              //             ),
                                              //             SizedBox(height: 10), // Adding some space between dropdown and selected value display
                                              //             Text(
                                              //               'Selected Value: ${selectedValue ?? ""}', // Display selected value or empty string if null
                                              //               style: TextStyle(fontSize: 16.0),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //             if (selectedValue == null)
                                              //               Padding(
                                              //                 padding: const EdgeInsets.only(top: 8.0),
                                              //                 child: Text(
                                              //                   "Please select a payment mode",
                                              //                   style: TextStyle(color: Colors.red),
                                              //                 ),
                                              //               ),
                                              //           ],
                                              //         );
                                              //       } else {
                                              //         return Text("No payment modes available");
                                              //       }
                                              //     } else {
                                              //       return Text("No data available");
                                              //     }
                                              //   },
                                              // ),
                                              Theme(
                                                data: ThemeData(
                                                  textTheme: TextTheme(
                                                      subtitle1: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                child: FutureBuilder(
                                                  future: Getresponse1(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState ==
                                                        ConnectionState.done) {
                                                      if (snapshot.hasData) {
                                                        List<PaymentModesDetails> list2 =
                                                        snapshot.data!;
                                                        return DropdownButtonFormField<
                                                            String>(
                                                          dropdownColor:
                                                          Colors.white,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15),
                                                          isExpanded: true,
                                                          value: selectedValue,
                                                          items: list2
                                                              .map((PaymentModesDetails item) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: item.paymentMode,
                                                              child: Text(
                                                                item.paymentMode!,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              selectedValue = value!;
                                                              selectedPaymentModeId = list2
                                                                                      .firstWhere((item) => item.paymentMode == value)
                                                                                      .paymentModeId!
                                                                                      .toString();
                                                            });
                                                            // Handle dropdown value change if needed
                                                          },
                                                          decoration:
                                                          InputDecoration(
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10.0,
                                                                horizontal: 10),
                                                            prefixIcon: Icon(
                                                                Icons
                                                                    .currency_rupee,
                                                                color: Colors.white),
                                                          ),
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            "${snapshot.error}");
                                                      }
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Amount:",
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    controller: amountcontroller,
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return "Please enter some amount";

                                                      }
                                                      double? enteredAmount = double.tryParse(value);
                                                      if (enteredAmount == null || enteredAmount <= 0) {
                                                        return 'Please enter a valid positive number';
                                                      }
                                                      String? toPayAmountStr = booking.balance;
                                                      double? toPayAmount = double.tryParse(toPayAmountStr ?? '');

                                                      if (toPayAmount == null) {
                                                        return 'Invalid to pay amount';
                                                      }
                                                      if (enteredAmount > toPayAmount) {
                                                        return 'Entered amount cannot exceed to pay';
                                                      }
                                                      return null; // Return null if the entered amount is valid
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      double enteredAmount = double.tryParse(value) ?? 0;
                                                      double toPayAmount = double.tryParse(booking.balance.toString()) ?? 0;
                                                      double remainingBalance = calculateRemainingBalance(toPayAmount, enteredAmount);
                                                      // Update the balance text field
                                                      balancecontroller.text = remainingBalance.toString();
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Balance :",
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller: balancecontroller,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      double enteredBalance = double.tryParse(value) ?? 0;
                                                      double toPayAmount = double.tryParse(booking.balance.toString()) ?? 0;
                                                      double remainingBalance = calculateRemainingBalance(toPayAmount, enteredBalance);
                                                      amountcontroller.text = (toPayAmount - remainingBalance).toString();
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Remarks :",
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),

                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    controller: remarkscontroller,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      // suffixIcon: Icon(Icons.arrow_drop_down),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  // Validate the form when "Pay" button is pressed
                                                  if (_formKey.currentState!.validate()) {
                                                    // Form is valid, proceed with payment
                                                    var bookingId = booking.bookingId.toString();
                                                    var receivedAmount = amountcontroller.text;
                                                    var paymentModeId = selectedPaymentModeId;
                                                    var paymentMode = selectedValue != null ? selectedValue.toString() : '';
                                                    var receivedOn = _dateController.text;
                                                    var remarks = remarkscontroller.text;

                                                    try {
                                                      final payDetails = await payupdate(
                                                        bookingId,
                                                        receivedAmount,
                                                        paymentModeId.toString(),
                                                        paymentMode,
                                                        receivedOn,
                                                        remarks,
                                                      );
                                                    } catch (e) {
                                                      // Handle API call error
                                                      print("Error: $e");
                                                    }
                                                  }
                                                  else{
                                                    print("object");
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.orange,
                                                  textStyle: TextStyle(fontSize: 16, color: Colors.white),
                                                  splashFactory: NoSplash.splashFactory,
                                                ),
                                                child: Text("Pay"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("Collect Balance"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "No data found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
  }
