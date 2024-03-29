import 'package:flutter/material.dart';

import 'screen 1.dart';
import 'screen4.dart';
class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>Screen1(),),);
            },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text("DashBoard",style: TextStyle(color: Colors.white),),
      ),
      body: SizedBox(
        height: 800,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15),
              child: Container(
                height: 100,
                width:MediaQuery.of(context).size.width *0.43,
                decoration: BoxDecoration(
                    border: Border.all(),borderRadius: BorderRadius.circular(20),
                    color: Colors.orange
                ),
                child: Center(child: Text("Booking Screen",style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(
              width: 35,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Screen4(),),);
              },
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width *0.43,
                decoration: BoxDecoration(
                    border: Border.all(),borderRadius: BorderRadius.circular(20),
                    color: Colors.orange
                ),
                child: Center(child: Text("Rooms Availability",style: TextStyle(color: Colors.white),)),
              ),
            )],
        ),
      ),
    );
  }
}