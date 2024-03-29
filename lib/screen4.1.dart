import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:http/http.dart' as http;
import 'Screen4.1.1class.dart';

class DatePage extends StatefulWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  late DateTime _selectedDate = DateTime.now();
  late TextEditingController monthController;
  List<RoomsDetails> roomsList = []; // List to store rooms fetched from API

  @override
  void initState() {
    super.initState();
    monthController = TextEditingController(
      text: '${_selectedDate.month}/${_selectedDate.year}',
    );
    fetchRooms(); // Fetch rooms when the page initializes
  }

  Future<void> fetchRooms() async {
    try {
      var response = await http.get(Uri.parse("http://92.205.109.210:8055/Rooms/GetRooms"));
      var data = jsonDecode(response.body)["roomsDetails"];
      List<RoomsDetails> rooms = (data as List).map((e) => RoomsDetails.fromJson(e)).toList();
      setState(() {
        roomsList = rooms;
      });
    } catch (error) {
      print("Error fetching rooms: $error");
      // Handle error appropriately, e.g., show an error message
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDate: _selectedDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        monthController.text = '${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        monthController.text = '${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Select Month",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 150,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      readOnly: true,
                      controller: monthController,
                      onTap: () {
                        _selectMonth(context);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _selectMonth(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Select Room",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: 150,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: null,
                      onChanged: (String? value) {},
                      items: roomsList.map((RoomsDetails room) {
                        return DropdownMenuItem<String>(
                          value: room.roomNo,
                          child: Text(
                            room.roomNo.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _selectDate(context); // Show date picker when the button is pressed
            },
            child: Text("Search"),
          ),
        ],
      ),
    );
  }
}
