import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController calendercontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    calendercontroller;
  }

  @override
  void dispose() {
  calendercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(

              firstDay: DateTime.utc(2022, 1, 1), // Set the first day to display
              lastDay: DateTime.utc(2022, 12, 31), // Set the last day to display
              focusedDay: DateTime.now(), // Set the initially focused day
            ),
          ],
        ),
      ),
    );
  }
}
