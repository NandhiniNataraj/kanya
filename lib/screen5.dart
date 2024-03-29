import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanya/screen5.1.model.dart';
import 'package:kanya/screen5.2class.dart';

class screen5 extends StatefulWidget {
  const screen5({Key? key}) : super(key: key);

  @override
  State<screen5> createState() => _screen5State();
}

class _screen5State extends State<screen5> {

  late Future<List<RoomsDetails>> _roomListFuture;

  @override
  void initState() {
    super.initState();
    _roomListFuture = getRoomList();
  }

  Future<List<RoomsDetails>> getRoomList() async {
    var response =
    await http.get(Uri.parse("http://92.205.109.210:8055/Rooms/GetRooms"));
    var data = jsonDecode(response.body)["roomsDetails"];
    return (data as List).map((e) => RoomsDetails.fromJson(e)).toList();
  }

  Future<Room>? pricedetails;

  bool isVisible = false;

  Future<Room> Addprice(int? roomId,String roomNo, String rupees) async {
    var resp = await http.post(
        Uri.parse("http://92.205.109.210:8055/Rooms/UpdateRoomsPrice"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "RoomId": roomId,
          "RoomNo": roomNo, // You might need to modify this if you have room number information
          "Price": rupees,
          "CreatedBy": 1
        }));
    var data = jsonDecode(resp.body);

    return Room.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Center(
            child: Text("Rooms Master", style: TextStyle(color: Colors.white))),
      ),
      body: FutureBuilder<List<RoomsDetails>>(
        future: _roomListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found'));
          } else {
            List<RoomsDetails> list = snapshot.data!;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showAlertDialog(context, list[index]);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Center(
                        child: Text(list[index].roomNo.toString()),
                      ),
                      trailing: Text(list[index].price.toString()),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAlertDialog(BuildContext context, RoomsDetails roomDetails) {
    TextEditingController priceController =
    TextEditingController(text: roomDetails.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Room Price"),
          content: TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: "Price",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String enteredPrice = priceController.text.trim();
                if (enteredPrice.isEmpty || double.parse(enteredPrice) <= 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid Price"),
                        content: Text("Please provide a valid price amount."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {

                  Navigator.of(context).pop();
                  final priceDetails = await Addprice(
                    roomDetails.roomId,
                    roomDetails.roomNo.toString(),
                    enteredPrice,
                  );
                  setState(() {
                    pricedetails = Future.value(priceDetails); // Convert Room to Future<Room>
                    isVisible = true;
                    _roomListFuture = getRoomList();
                  });

                }
              },
              child: Text("Update"),
            ),
            Visibility(
              visible: isVisible,
              child: FutureBuilder(
                future: pricedetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final clientDetail = snapshot.data!;
                    if (clientDetail.success == true) {
                      return Container(
                        height: 70,
                        decoration: BoxDecoration(
                        ),
                        child: Text("Added succesfully",style: TextStyle(color: Colors.white),),
                      );
                    }
                    else {
                      return Text("Not Added");
                    }
                  } else {
                    return SizedBox(); // Return an empty SizedBox to hide the text
                  }
                },
              ),
            ),

          ],
        );
      },
    );
  }
}
