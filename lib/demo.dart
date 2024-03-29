import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'bookscreenclass.dart';

class Screen4 extends StatefulWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  bool visibility = false;
  List<AvailRoomsByDate> roomList = [];

  Future<List<AvailRoomsByDate>> getAvailableRooms(String checkin, String checkout) async {
    try {
      final response = await http.post(
        Uri.parse("http://92.205.109.210:8055/Booking/GetAvailRoomsByDate"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          "CheckInDateTime": checkin,
          "CheckOutDateTime": checkout,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["availableroomsdate"];
        return (data as List).map((e) => AvailRoomsByDate.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load available rooms');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load available rooms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room Availability"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "From Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _fromDateController,
              readOnly: true,
              onTap: () => _selectDate(_fromDateController),
              decoration: InputDecoration(
                hintText: 'Select From Date',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "To Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _toDateController,
              readOnly: true,
              onTap: () => _selectDate(_toDateController),
              decoration: InputDecoration(
                hintText: 'Select To Date',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final checkin = _fromDateController.text;
                  final checkout = _toDateController.text;
                  final rooms = await getAvailableRooms(checkin, checkout);
                  setState(() {
                    roomList = rooms;
                    visibility = true;
                  });
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to load available rooms. Please try again.'),
                  ));
                }
              },
              child: Text("Search"),
            ),
            SizedBox(height: 20),
            if (visibility)
              Expanded(
                child: ListView.builder(
                  itemCount: roomList.length,
                  itemBuilder: (context, index) {
                    final room = roomList[index];
                    return ListTile(
                      title: Text("Room No: ${room.roomNo}"),
                      subtitle: Text("Price: ${room.price}"),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      _selectTime(controller, picked);
    }
  }

  Future<void> _selectTime(
      TextEditingController controller, DateTime selectedDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );
        controller.text = selectedDateTime.toString();
      });
    }
  }
}
